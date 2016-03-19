# encoding: UTF-8

=begin
  @todo Reorganize the code with methods rslpLoaderStemmer, rslpProcessWord and rslpUnloadStemmer
  Url with rules: http://alvinalexander.com/java/jwarehouse/lucene/contrib/analyzers/common/src/resources/org/apache/lucene/analysis/pt/portuguese.rslp.shtml
  Algorithm explained in portuguese: http://www.lume.ufrgs.br/bitstream/handle/10183/23576/000597277.pdf?sequence=1
  Utils: http://www.inf.ufrgs.br/~viviane/rslp/
=end

require "brstemmer/version"

module Brstemmer
  # Steps file for the RSLP stemmer.
  # Step 1: Plural Reduction
  RULES = [
      {
          :properties => { name: "plural_reduction", size:3, exceptions:1},
          :rules => [
              # bons -> bom
              ["ns",1,"m"],
              # balões -> balão
              ["ões",3,"ão"],
              # capitães -> capitão
              ["ães",1,"ão",["mães"]],
              # normais -> normal
              ["ais",1,"al",["cais","mais"]],
              # papéis -> papel
              ["éis",2,"el"],
              # amáveis -> amável
              ["eis",2,"el"],
              # lençóis -> lençol
              ["óis",2,"ol"],
              # barris -> barril
              ["is",2,"il",["lápis","cais","mais","crúcis","biquínis","pois","depois","dois","leis"]],
              # males -> mal
              ["les",3,"l"],
              # mares -> mar
              ["res",3,"r", ["árvores"]],
              # casas -> casa
              ["s",2,"",["aliás","pires","lápis","cais","mais","mas","menos","férias","fezes","pêsames","crúcis","gás","atrás","moisés","através","convés","ês","país","após","ambas","ambos","messias", "depois"]]
          ]
      },

      # Step 2: Adverb Reduction
      {
          :properties => { name:"adverb_reduction", size:0, exceptions:0 },
          :rules => [
              # felizmente -> feliz
              ["mente",4,"",["experimente"]]
          ]
      },

      # Step 3: Feminine Reduction
      {
          :properties => { name:"feminine_reduction", size:3, exceptions:1 },
          :rules => [
              # chefona -> chefão
              ["ona",3,"ão",["abandona","lona","iona","cortisona","monótona","maratona","acetona","detona","carona"]],
              # vilã -> vilão
              ["ã",2,"ão",["amanhã","arapuã","fã","divã"]],
              # professora -> professor
              ["ora",3,"or"],
              # americana -> americano
              ["na",4,"no",["carona","abandona","lona","iona","cortisona","monótona","maratona","acetona","detona","guiana","campana","grana","caravana","banana","paisana"]],
              # sozinha -> sozinho
              ["inha",3,"inho",["rainha","linha","minha"]],
              # inglesa -> inglês
              ["esa",3,"ês",["mesa","obesa","princesa","turquesa","ilesa","pesa","presa"]],
              # famosa -> famoso
              ["osa",3,"oso",["mucosa","prosa"]],
              # maníaca -> maníaco
              ["íaca",3,"íaco"],
              # prática -> prático
              ["ica",3,"ico",["dica"]],
              # cansada -> cansado
              ["ada",2,"ado",["pitada"]],
              # mantida -> mantido
              ["ida",3,"ido",["vida","dúvida"]],
              ["ída",3,"ido",["recaída","saída"]],
              # prima -> primo
              ["ima",3,"imo",["vítima"]],
              # passiva -> passivo
              ["iva",3,"ivo",["saliva","oliva"]],
              # primeira -> primeiro
              ["eira",3,"eiro",["beira","cadeira","frigideira","bandeira","feira","capoeira","barreira","fronteira","besteira","poeira"]]
          ]
      },

      # Step 4: Augmentative/Diminutive Reduction
      {
          :properties => { name:"augmentative_reduction", size:0, exceptions:1 },
          :rules => [
              # cansadíssimo -> cansad
              ["díssimo",5],
              # amabilíssimo -> ama
              ["abilíssimo",5],
              # fortíssimo -> fort
              ["íssimo",3],
              ["ésimo",3],
              # chiquérrimo -> chiqu
              ["érrimo",4],
              # pezinho -> pe
              ["zinho",2],
              # maluquinho -> maluc
              ["quinho",4,"c"],
              # amiguinho -> amig
              ["uinho",4],
              # cansadinho -> cansad
              ["adinho",3],
              # carrinho -> carr
              ["inho",3,"",["caminho","cominho"]],
              # grandalhão -> grand
              ["alhão",4],
              # dentuça -> dent
              ["uça",4],
              # ricaço -> ric
              ["aço",4,"",["antebraço"]],
              ["aça",4],
              # casadão -> cans
              ["adão",4],
              ["idão",4],
              # corpázio -> corp
              ["ázio",3,"",["topázio"]],
              # pratarraz -> prat
              ["arraz",4],
              ["zarrão",3],
              ["arrão",4],
              # bocarra -> boc
              ["arra",3],
              # calorzão -> calor
              ["zão",2,"",["coalizão"]],
              # meninão -> menin
              ["ão",3,"",["camarão","chimarrão","canção","coração","embrião","grotão","glutão","ficção","fogão","feição","furacão","gamão","lampião","leão","macacão","nação","órfão","orgão","patrão","portão","quinhão","rincão","tração","falcão","espião","mamão","folião","cordão","aptidão","campeão","colchão","limão","leilão","melão","barão","milhão","bilhão","fusão","cristão","ilusão","capitão","estação","senão"]]
          ]
      },

      # Step 5: Noun Suffix Reduction
      {
          :properties => { name:"noun_reduction", size:0, exceptions:0 },
          :rules => [
              # existencialista -> exist
              ["encialista",4],
              # minimalista -> minim
              ["alista",5],
              # contagem -> cont
              ["agem",3,"",["coragem","chantagem","vantagem","carruagem"]],
              # gerenciamento -> gerenc
              ["iamento",4],
              # monitoramento -> monitor
              ["amento",3,"",["firmamento","fundamento","departamento"]],
              # nascimento -> nasc
              ["imento",3],
              ["mento",6,"",["firmamento","elemento","complemento","instrumento","departamento"]],
              # comercializado -> comerci
              ["alizado",4],
              # traumatizado -> traum
              ["atizado",4],
              ["tizado",4,"",["alfabetizado"]],
              # alfabetizado -> alfabet
              ["izado",5,"",["organizado","pulverizado"]],
              # associativo -> associ
              ["ativo",4,"",["pejorativo","relativo"]],
              # contraceptivo -> contracep
              ["tivo",4,"",["relativo"]],
              # esportivo -> esport
              ["ivo",4,"",["passivo","possessivo","pejorativo","positivo"]],
              # abalado -> abal
              ["ado",2,"",["grado"]],
              # impedido -> imped
              ["ido",3,"",["cândido","consolido","rápido","decido","tímido","duvido","marido"]],
              # ralador -> ral
              ["ador",3],
              # entendedor -> entend
              ["edor",3],
              # cumpridor -> cumpr
              ["idor",4,"",["ouvidor"]],
              ["dor",4,"",["ouvidor"]],
              ["sor",4,"",["assessor"]],
              ["atoria",5],
              ["tor",3,"",["benfeitor","leitor","editor","pastor","produtor","promotor","consultor"]],
              ["or",2,"",["motor","melhor","redor","rigor","sensor","tambor","tumor","assessor","benfeitor","pastor","terior","favor","autor"]],
              # comparabilidade -> compar
              ["abilidade",5],
              # abolicionista -> abol
              ["icionista",4],
              # intervencionista -> interven
              ["cionista",5],
              ["ionista",5],
              ["ionar",5],
              # profissional -> profiss
              ["ional",4],
              # referência -> refer
              ["ência",3],
              # repugnância -> repugn
              ["ância",4,"",["ambulância"]],
              # abatedouro -> abat
              ["edouro",3],
              # fofoqueiro -> fofoc
              ["queiro",3,"c"],
              ["adeiro",4,"",["desfiladeiro"]],
              # brasileiro -> brasil
              ["eiro",3,"",["desfiladeiro","pioneiro","mosteiro"]],
              ["uoso",3],
              # gostoso -> gost
              ["oso",3,"",["precioso"]],
              # comercializaç -> comerci
              ["alizaç",5],
              ["atizaç",5],
              ["tizaç",5],
              ["izaç",5,"",["organizaç"]],
              # alegaç -> aleg
              ["aç",3,"",["equaç","relaç"]],
              # aboliç -> abol
              ["iç",3,"",["eleiç"]],
              # anedotário -> anedot
              ["ário",3,"",["voluntário","salário","aniversário","diário","lionário","armário"]],
              ["atório",3],
              ["rio",5,"",["voluntário","salário","aniversário","diário","compulsório","lionário","próprio","stério","armário"]],
              # ministério -> minist
              ["ério",6],
              # chinês -> chin
              ["ês",4],
              # beleza -> bel
              ["eza",3],
              # rigidez -> rigid
              ["ez",4],
              # parentesco -> parent
              ["esco",4],
              # ocupante -> ocup
              ["ante",2,"",["gigante","elefante","adiante","possante","instante","restaurante"]],
              # bombástico -> bomb
              ["ástico",4,"",["eclesiástico"]],
              ["alístico",3],
              ["áutico",4],
              ["êutico",4],
              ["tico",3,"",["político","eclesiástico","diagnostico","prático","doméstico","diagnóstico","idêntico","alopático","artístico","autêntico","eclético","crítico","critico"]],
              # polêmico -> polêm
              ["ico",4,"",["tico","público","explico"]],
              # produtividade -> produt
              ["ividade",5],
              # profundidade -> profund
              ["idade",4,"",["autoridade","comunidade"]],
              # aposentadoria -> aposentad
              ["oria",4,"",["categoria"]],
              # existencial -> exist
              ["encial",5],
              # artista -> art
              ["ista",4],
              ["auta",5],
              # maluquice -> maluc
              ["quice",4,"c"],
              # chatice -> chat
              ["ice",4,"",["cúmplice"]],
              # demoníaco -> demon
              ["íaco",3],
              # decorrente -> decorr
              ["ente",4,"",["freqüente","alimente","acrescente","permanente","oriente","aparente"]],
              ["ense",5],
              # criminal -> crim
              ["inal",3],
              # americano -> americ
              ["ano",4],
              # amável -> am
              ["ável",2,"",["afável","razoável","potável","vulnerável"]],
              # combustível -> combust
              ["ível",3,"",["possível"]],
              ["vel",5,"",["possível","vulnerável","solúvel"]],
              ["bil",3,"vel"],
              # cobertura -> cobert
              ["ura",4,"",["imatura","acupuntura","costura"]],
              ["ural",4],
              # consensual -> consens
              ["ual",3,"",["bissexual","virtual","visual","pontual"]],
              # mundial -> mund
              ["ial",3],
              # experimental -> experiment
              ["al",4,"",["afinal","animal","estatal","bissexual","desleal","fiscal","formal","pessoal","liberal","postal","virtual","visual","pontual","sideral","sucursal"]],
              ["alismo",4],
              ["ivismo",4],
              ["ismo",3,"",["cinismo"]]
          ]
      },

      # Step 6: Verb Suffix Reduction
      {
          :properties => { name:"verb_reduction", size:0, exceptions:0 },
          :rules => [
              # cantaríamo -> cant
              ["aríamo",2],
              # cantássemo -> cant
              ["ássemo",2],
              # beberíamo -> beb
              ["eríamo",2],
              # bebêssemo -> beb
              ["êssemo",2],
              # partiríamo -> part
              ["iríamo",3],
              # partíssemo -> part
              ["íssemo",3],
              # cantáramo -> cant
              ["áramo",2],
              # cantárei -> cant
              ["árei",2],
              # cantaremo -> cant
              ["aremo",2],
              # cantariam -> cant
              ["ariam",2],
              # cantaríei -> cant
              ["aríei",2],
              # cantássei -> cant
              ["ássei",2],
              # cantassem -> cant
              ["assem",2],
              # cantávamo -> cant
              ["ávamo",2],
              # bebêramo -> beb
              ["êramo",3],
              # beberemo -> beb
              ["eremo",3],
              # beberiam -> beb
              ["eriam",3],
              # beberíei -> beb
              ["eríei",3],
              # bebêssei -> beb
              ["êssei",3],
              # bebessem -> beb
              ["essem",3],
              # partiríamo -> part
              ["íramo",3],
              # partiremo -> part
              ["iremo",3],
              # partiriam -> part
              ["iriam",3],
              # partiríei -> part
              ["iríei",3],
              # partíssei -> part
              ["íssei",3],
              # partissem -> part
              ["issem",3],
              # cantando -> cant
              ["ando",2],
              # bebendo -> beb
              ["endo",3],
              # partindo -> part
              ["indo",3],
              # propondo -> prop
              ["ondo",3],
              # cantaram -> cant
              ["aram",2],
              ["arão",2],
              # cantarde -> cant
              ["arde",2],
              # cantarei -> cant
              ["arei",2],
              # cantarem -> cant
              ["arem",2],
              # cantaria -> cant
              ["aria",2],
              # cantarmo -> cant
              ["armo",2],
              # cantasse -> cant
              ["asse",2],
              # cantaste -> cant
              ["aste",2],
              # cantavam -> cant
              ["avam",2,"",["agravam"]],
              # cantávei -> cant
              ["ávei",2],
              # beberam -> beb
              ["eram",3],
              ["erão",3],
              # beberde -> beb
              ["erde",3],
              # beberei -> beb
              ["erei",3],
              # bebêrei -> beb
              ["êrei",3],
              # beberem -> beb
              ["erem",3],
              # beberia -> beb
              ["eria",3],
              # bebermo -> beb
              ["ermo",3],
              # bebesse -> beb
              ["esse",3],
              # bebeste -> beb
              ["este",3,"",["faroeste","agreste"]],
              # bebíamo -> beb
              ["íamo",3],
              # partiram -> part
              ["iram",3],
              # concluíram -> conclu
              ["íram",3],
              ["irão",2],
              # partirde -> part
              ["irde",2],
              # partírei -> part
              ["irei",3,"",["admirei"]],
              # partirem -> part
              ["irem",3,"",["adquirem"]],
              # partiria -> part
              ["iria",3],
              # partirmo -> part
              ["irmo",3],
              # partisse -> part
              ["isse",3],
              # partiste -> part
              ["iste",4],
              ["iava",4,"",["ampliava"]],
              # cantamo -> cant
              ["amo",2],
              ["iona",3],
              # cantara -> cant
              ["ara",2,"",["arara","prepara"]],
              # cantará -> cant
              ["ará",2,"",["alvará"]],
              # cantare -> cant
              ["are",2,"",["prepare"]],
              # cantava -> cant
              ["ava",2,"",["agrava"]],
              # cantemo -> cant
              ["emo",2],
              # bebera -> beb
              ["era",3,"",["acelera","espera"]],
              # beberá -> beb
              ["erá",3],
              # bebere -> beb
              ["ere",3,"",["espere"]],
              # bebiam -> beb
              ["iam",3,"",["enfiam","ampliam","elogiam","ensaiam"]],
              # bebíei -> beb
              ["íei",3],
              # partimo -> part
              ["imo",3,"",["reprimo","intimo","íntimo","nimo","queimo","ximo"]],
              # partira -> part
              ["ira",3,"",["fronteira","sátira"]],
              ["ído",3],
              # partirá -> part
              ["irá",3],
              ["tizar",4,"",["alfabetizar"]],
              ["izar",5,"",["organizar"]],
              ["itar",5,"",["acreditar","explicitar","estreitar"]],
              # partire -> part
              ["ire",3,"",["adquire"]],
              # compomo -> comp
              ["omo",3],
              # cantai -> cant
              ["ai",2],
              # cantam -> cant
              ["am",2],
              # barbear -> barb
              ["ear",4,"",["alardear","nuclear"]],
              # cantar -> cant
              ["ar",2,"",["azar","bazaar","patamar"]],
              # cheguei -> cheg
              ["uei",3],
              ["uía",5,"u"],
              # cantei -> cant
              ["ei",3],
              ["guem",3,"g"],
              # cantem -> cant
              ["em",2,"",["alem","virgem"]],
              # beber -> beb
              ["er",2,"",["éter","pier"]],
              # bebeu -> beb
              ["eu",3,"",["chapeu"]],
              # bebia -> beb
              ["ia",3,"",["estória","fatia","acia","praia","elogia","mania","lábia","aprecia","polícia","arredia","cheia","ásia"]],
              # partir -> part
              ["ir",3,"",["freir"]],
              # partiu -> part
              ["iu",3],
              ["eou",5],
              # chegou -> cheg
              ["ou",3],
              # bebi -> beb
              ["i",3]
          ]
      },

      # Step 7: Vowel Removal
      {
          :properties => { name:"vowel_reduction", size:0, exceptions:0 },
          :rules => [
              ["bil",2,"vel"],
              ["gue",2,"g",["gangue","jegue"]],
              ["á",3],
              ["ê",3,"",["bebê"]],
              # menina -> menin
              ["a",3,"",["ásia"]],
              # grande -> grand
              ["e",3],
              # menino -> menin
              ["o",3,"",["ão"]]
          ]
      },
      # Step 8: Remove accents
      {
          :properties => { name:"accent_reduction", size:0, exceptions:0 },
          :rules => [
              ["á",1,"a"],
              ["â",1,"a"],
              ["ó",1,"o"],
              ["ô",1,"o"],
              ["é",1,"e"],
              ["í",1,"i"],
              ["ú",1,"u"],
          ]
      }
  ]

  def stemmer
    stemmer = Stemmer.new self.dup.to_s
    stemmer.render
  end

  class Stemmer

    def initialize word
      @suffix_removed = false
      @word = word
      @rules = RULES.freeze

      self
    end

    def render
      @word.downcase!

      self.apply_rules_by_name('plural_reduction') if @word[-1] == 's'
      self.apply_rules_by_name('adverb_reduction')
      self.apply_rules_by_name('feminine_reduction') if @word[-1] == 'a' or @word[-1] == "ã"
      self.apply_rules_by_name('augmentative_reduction')
      self.apply_rules_by_name('noun_reduction')
      self.apply_rules_by_name('verb_reduction') unless @suffix_removed
      self.apply_rules_by_name('vowel_reduction') unless @suffix_removed
      self.apply_rules_by_name('accent_reduction')
    end

    def apply_rules_by_name(name)
      rules = @rules.detect { |rule| rule[:properties][:name] == name }
      rules[:rules].each do |rule|
        if rule[2].nil?
          self.apply_suffix rule[0], rule[1], rule[3]
        else
          self.apply_suffix rule[0], rule[1], rule[2], rule[3]
        end
      end

      @word
    end

    # @params:
    #   suffix   => Suffix to remove
    #   size     => Minimal size of stem
    #   replaced => Replace suffix
    #   excpt    => Exceptions words or suffix list
    def apply_suffix(suffix, size, replaced='', excpts)
      aux_word = @word
      if @word =~ /#{suffix}$/
        @word.gsub!(/#{suffix}$/, replaced) if
            (not excpts.nil? and excpts.detect { |expt| @word == expt }.nil? or excpts.nil?) and @word.length - suffix.length >= size
      end

      @suffix_removed = true if aux_word != @word
    end

    @word
  end
end

class String
  def brstemmer
    word = StemmifyHelper::Stemmer.new self.dup.to_s
    word.render
  end
end

