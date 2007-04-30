Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbXD3OJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbXD3OJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbXD3OJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:09:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:37897 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755274AbXD3OJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:09:18 -0400
Cc: hermann-pitton@arcor.de, mkrufky@linuxtv.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-dvb@linuxtv.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 30 Apr 2007 16:09:16 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <d9def9db0704300606r34e0d05av4a9b54eeae94b404@mail.gmail.com>
Message-ID: <20070430140916.66690@gmx.net>
MIME-Version: 1.0
References: <20070429182209.267430@gmx.net>	
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org>	
 <20070429205925.129920@gmx.net>	
 <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>	
 <20070429230037.95120@gmx.net>	 <1177894713.3046.5.camel@pc06.localdom.local>
	 <20070430110255.267000@gmx.net>	
 <d9def9db0704300448g6d7f4bd2ob7d6117d6c5f0cfb@mail.gmail.com>	
 <20070430123716.119970@gmx.net>
 <d9def9db0704300606r34e0d05av4a9b54eeae94b404@mail.gmail.com>
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
 pseudo-authorities
To: "Markus Rechberger" <mrechberger@gmail.com>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18PbtBv27IPSgZq0fOH74YPXxdGfL0yt1cUdV7meU
 iFTCHLro21Js6VIqOa+qVp+MAdMLVkkHOXjQ== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: xL5TLGVsaHItSn7cWSUlv+hiamdhZMRw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Mon, 30 Apr 2007 15:06:11 +0200
Von: "Markus Rechberger" <mrechberger@gmail.com>
An: "Uwe Bugla" <uwe.bugla@gmx.de>
CC: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, mkrufky@linuxtv.org, hermann-pitton@arcor.de
Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and pseudo-authorities

> On 4/30/07, Uwe Bugla <uwe.bugla@gmx.de> wrote:
> >
> > -------- Original-Nachricht --------
> > Datum: Mon, 30 Apr 2007 13:48:34 +0200
> > Von: "Markus Rechberger" <mrechberger@gmail.com>
> > An: "Uwe Bugla" <uwe.bugla@gmx.de>
> > CC: "hermann pitton" <hermann-pitton@arcor.de>, mkruky@linuxtv.org,
> > akpm@linux-foundation.org, torvalds@linux-foundation.org,
> > linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
> > Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
> > pseudo-authorities
> >
> > > On 4/30/07, Uwe Bugla <uwe.bugla@gmx.de> wrote:
> > > >
> > > > -------- Original-Nachricht --------
> > > > Datum: Mon, 30 Apr 2007 02:58:33 +0200
> > > > Von: hermann pitton <hermann-pitton@arcor.de>
> > > > An: Uwe Bugla <uwe.bugla@gmx.de>
> > > > CC: Linus Torvalds <torvalds@linux-foundation.org>,
> mkruky@linuxtv.org,
> > > > akpm@linux-foundation.org, linux-dvb@linuxtv.org,
> > > > linux-kernel@vger.kernel.org
> > > > Betreff: Re: [linux-dvb] Re: Critical points about kernel 2.6.21
> > > > and	pseudo-authorities
> > > >
> > > > > Am Montag, den 30.04.2007, 01:00 +0200 schrieb Uwe Bugla:
> > > > > > -------- Original-Nachricht --------
> > > > > > Datum: Sun, 29 Apr 2007 14:19:22 -0700 (PDT)
> > > > > > Von: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > > An: Uwe Bugla <uwe.bugla@gmx.de>
> > > > > > CC: linux-dvb@linuxtv.org, mkruky@linuxtv.org,
> > > mchehab@infradead.org,
> > > > > linux-kernel@vger.kernel.org, akpm@linux-foundation.org
> > > > > > Betreff: Re: Critical points about kernel 2.6.21 and
> > > pseudo-authorities
> > > > > >
> > > > > > >
> > > > > > >
> > > > > > > On Sun, 29 Apr 2007, Uwe Bugla wrote:
> > > > > > > >
> > > > > > > > I have been trying diff and other tools in various variants
> > > (except
> > > > > > > > git-bisect that I cannot handle because I do not understand
> the
> > > > > practice
> > > > > > > > of it).
> > > > > > >
> > > > > > > git bisect is _really_ simple if you already have a git tree
> > > anyway.
> > > > > And
> > > > > > > even if you don't, getting one isn't really hard either. Just
> do
> > > > > > >
> > > > > > > 	git clone
> > > > > > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > > > > linux-2.6
> > > > > > >
> > > > > > > and you have a tree (it will take a little while - it's going
> to
> > > > > dowload
> > > > > > > about 170MB or so of stuff, so the initial clone is going to
> be a
> > > bit
> > > > > > > painful unless you have a fast internet connection).
> > > > > > >
> > > > > > > Once you have the git tree, assuming that 2.6.21-rc7 worked
> for
> > > you,
> > > > > it's
> > > > > > > really as easy as just saying
> > > > > > >
> > > > > > > 	git bisect start
> > > > > > > 	git bisect good v2.6.21-rc7
> > > > > > > 	git bisect bad v2.6.21
> > > > > > >
> > > > > > > and git will think for a short while (most of the time is
> going to
> > > be
> > > > > > > checking out the new tree) and give you a tree to test.
> > > > > > >
> > > > > > > Just build, boot, and test that tree.
> > > > > > >
> > > > > > > If it was fine, do
> > > > > > >
> > > > > > > 	git bisect good
> > > > > > >
> > > > > > > and git will pick a new tree to test. And if it wasn't,
> instead
> > > just
> > > > > do
> > > > > > > "git bisect bad", and git will pick _another_ version to test.
> Do
> > > this
> > > > > a
> > > > > > > few times, and git will tell you which commit introduced them.
> > > > > > >
> > > > > > > There were just 125 commits in between 2.6.21-rc7 and the
> final
> > > one,
> > > > > so it
> > > > > > > should be quite quick - bisection basically does a binary
> search,
> > > so
> > > > > doing
> > > > > > > seven reboots should have you with the result.
> > > > > > >
> > > > > > > The fact that it already works in 2.6.21-git2 obviously means
> that
> > > _I_
> > > > > end
> > > > > > > up being less interested, but the -stable tree people would
> love
> > > to
> > > > > hear
> > > > > > > what broke!
> > > > > >
> > > > > > Hi again Linus,
> > > > > > my deep thanks for your excellent explication of git-bisect.
> > > > > > But I unfortunately owe a 100Kbit flatrate, and so downloading
> some
> > > 170
> > > > > MB git tree will need the time amount of one entire night (11.5 kb
> /s
> > > if I
> > > > > am lucky - no more).
> > > > > > Just to take up a different approach:
> > > > > >
> > > > > > The difference between 2.6.21-rc7 and 2.6.21 official does not
> play
> > > any
> > > > > role at all.
> > > > > >
> > > > > > On the other hand I found out that:
> > > > > > 2.6.21-rc7 made my AMD K7 router work fine
> > > > > > 2.6.21 official hung my AMD K7 router up
> > > > > > 2.6.21-git1 hung my AMD K7 router up
> > > > > > 2.6.21-git2 made my AMD K7 router work.
> > > > > >
> > > > > > In so far the diff between 2.6.21-git1 and 2.6.21-git2 obviously
> > > solves
> > > > > the problem.
> > > > > > Or am I saying something wrong as far as logical terms are
> > > concerned?
> > > > > >
> > > > > > >
> > > > > > > > I like small and effective kernels instead of blown up RAM
> > > waste.
> > > > > > > > This is no Windoze, man, this is Linux!
> > > > > > >
> > > > > > > Yes. But if you cannot be polite and *RESPECTFUL*, you won't
> get
> > > > > anywhere
> > > > > > > at all.
> > > > > > >
> > > > > > > This is Linux, not Windows. But that also means that those
> > > developers
> > > > > that
> > > > > > > you denigrate aren't getting paid by you, and if you don't
> show
> > > them
> > > > > > > respect, they'll totally ignore you.
> > > > > > >
> > > > > > > 		Linus
> > > > > >
> > > > > > Now this is the old problem about it all: the hypocricy factor,
> the
> > > > > utmost small, if not to say pre-pubertarian character plus some
> other
> > > > obviously
> > > > > counter-productive character traits in those so-called
> "maintainers"
> > > who
> > > > > behave like kids, but not like grown-ups at all!
> > > > > > Not only you, but also Andrew perfectly and willingly step into
> the
> > > > > hypocritic trap and do not even feel that they are trapped!
> > > > > >
> > > > > > For the majority of all cases of the so-called "maintainer
> > > personnel" at
> > > > > linuxtv.org the statement of some missing "politeness" or some
> missing
> > > > > "respect" is nothing but an utmost dumb, kiddish, human mediocre
> and
> > > > utmost
> > > > > stupid and utmost hypocritic excuse for bare naked
> incompatibility,
> > > > dumbness,
> > > > > wrong solidarity, kiddishness and technical incompetence.
> > > > > >
> > > > > > They are building up pseudo-authorities to hide their lack of
> > > > > competence, no matter if their lack of competence funds on
> technical
> > > or
> > > > human lacks.
> > > > > > And at least the Brazilian Mauro Carvalho Chehab does go even so
> far
> > > to
> > > > > soap in Andrew Morton's face with this enourmous threat of
> > > incompetence,
> > > > > kiddishness, incompatibility, hypocricy, lies, stigmatisations,
> > > > stubbornness,
> > > > > lack of experience, pre-pubertarian behaviour, fascistoid opinion
> > > > > dictatorship as part of a deep immature anti-democratic and
> > > reactionary
> > > > personality
> > > > > structure.
> > > > > >
> > > > > > Would you call Mauro Carvalho Chehab a maintainer!
> > > > > > I can certify you that I cannot, even if I try. And I want him
> to be
> > > > > substituted as quick as possible as he is the biggest mismatch of
> > > > gatekeeper
> > > > > one can ever imagine.
> > > > > >
> > > > > > And it is not only me personally perceiving this that there are
> > > people
> > > > > missing who can go upright and offer sophisticated and good work.
> > > > > > Plus a real sophisticated discussion behaviour, in technical and
> in
> > > > > human terms.
> > > > > > Going upright is thus far away from the behaviour NOT to be able
> to
> > > > > tolerate any criticism at all.
> > > > > >
> > > > > > Solution: This whole new quite young linuxtv.org team is missing
> a
> > > real
> > > > > grown up and experienced team leader. Not only that is definitely
> too
> > > much
> > > > > for Mauro Carvalho Chehab. That is the pain - the consistence of
> the
> > > whole
> > > > > group is the pain, that's all. Too young, too many lacks of human
> > > skills,
> > > > > and missing an appropriate team leader.............
> > > > > >
> > > > > > So, if I show respect or not, or if I show politeness or not
> will
> > > never
> > > > > change the whole structural situation at all, as great parts of
> the
> > > whole
> > > > > team is a disease:
> > > > > > 1. By Chehab being the team leader the whole fish stinks from
> the
> > > head
> > > > > startup.
> > > > > > Solution: Substitution of Mauro Carvalho Chehab as quick as
> possible
> > > -
> > > > > even quicker than a storm!
> > > > > > 2. By Krufky being one part of it, doing good work, but
> executing
> > > wrong
> > > > > solidarities by his bowing behaviour towards pseudo-authorities
> > > although
> > > > he
> > > > > knows better at least technically this is a question of wrong or
> right
> > > > > leadership, nothing else
> > > > > > 3. By Abraham offering us great ranting aims that never are
> being
> > > put
> > > > > into practice out of certified missing human skills and missing
> > > technical
> > > > > knowledge (the four completely unusable 2.6 kernels were never
> > > apologized
> > > > by
> > > > > himself) urgent substitution  is utmost necessary.
> > > > > >
> > > > > > CLEARER: If anyone of the people knowing the deeper context
> claims
> > > those
> > > > > "gatekeeper methods" to be a consequence of missing "respect" or
> > > missing
> > > > > "politeness" then those people are either strictly dumb and
> > > superficial,
> > > > or
> > > > > they owe a gesture that I would call a "Well, I know, but I do not
> > > want to
> > > > > see what's going on"-disease, nothing else.
> > > > > >
> > > > > > Another term to describe the latter would be "bureaucratic lamb
> head
> > > > > behaviour".
> > > > > >
> > > > > > See, Linus, if for instance Andrew Morton mails me some
> statement
> > > from
> > > > > that Chehab going: "Again, do not take the patches from Uwe - he
> is
> > > always
> > > > > regarding things through his personal prisma, and the rest he
> simply
> > > does
> > > > > not perceive at all"
> > > > > >
> > > > > > then this is nothing but a gesture full of lies (somehow typical
> for
> > > > > this Brazilian fascistoid opinion block head dictator), but it
> simply
> > > > shows
> > > > > that the linuxtv.org teamleader is a horrible mismatch, nothing
> else!
> > > > > >
> > > > > > His mediocrity and dumbness simply defines through the fact that
> he
> > > is
> > > > > using stigmatizations very soon in a so-called "discussion"
> because he
> > > > > misses
> > > > > > a. human skills
> > > > > > b. technical proven arguments and theses
> > > > > > c. enough experience, human or technical one.
> > > > > >
> > > > > > And the biggest threat and shame is the proven fact that Andrew
> > > Morton
> > > > > does obey to such a stupid reactionary idiot and let his face soap
> in
> > > by
> > > > > this dirty Brazilian hypocrite instead of giving contributions at
> > > least a
> > > > > chance through his mm-tree.
> > > > > >
> > > > > > So there are exactly two solutions:
> > > > > > 1. Andrew Morton should not obey to Chehab anymore and be real
> open
> > > > > > 2. Chehab and Abraham should be substituted as quick as possible
> > > without
> > > > > any hesitation in no way!!!!
> > > > > >
> > > > > > The one that got to be fired with the most urgent priority is
> called
> > > > > Mauro Carvalho Chehab. This is no maintainer, this is no
> gatekeeper,
> > > but
> > > > this
> > > > > is nothing but a real personified ape or disease.
> > > > > >
> > > > > > And the argument whether those people are paid for their work or
> not
> > > is
> > > > > exactly as important as if a sack of rice falls down somewhere in
> > > > > capitalist China or not.....
> > > > > > OBSOLETE!!!
> > > > > >
> > > > > > Yours sincerely
> > > > > > Uwe
> > > > > >
> > > > >
> > > > > If eventually somebody thinks this kind of stuff could be helpful,
> > > > > please say so and give us some pointers.
> > > > >
> > > > > Hermann
> > > > >
> > > > Hi Hermann,
> > > >
> > > > now if you are searching for helpful stuff I can make public a ten
> > > Emails
> > > > ping pong
> > > > betwwen stupid Chehab and me about my almost excellent
> dst-deselection
> > > patch
> > > > contributions.
> > > >
> > > > In this ten Emails you will yourself see the intellectual and
> technical
> > > > proof in how far Mr. Chehab is acting with nothing else but:
> > > >
> > > > a. Lies
> > > > b. Unproven thesis
> > > > c. Stigmatizations
> > > >
> > > > and so on.
> > > >
> > > > THIS MAN HAS NO IDEA, BUT HE HAS THE POWER!
> > > >
> > > > That's it what I cannot live with!
> > > > I swear I never stumbled over such an utomst stubborn, stupid and
> > > horrible
> > > > idiot in my whole year lasting Linux experience, and I thought I
> could
> > > not
> > > > trust my eyes when I saw what incredible crap work was pushed into
> > > mainline
> > > > by the signature of this
> > > > incredible and horrible team chief from Brazil.
> > > >
> > > > If you want to see the Emails, just ask me and I will forward them
> with
> > > a
> > > > couple of CCs. They will show the truth about the real consistence
> of
> > > this
> > > > "maintainer leader".
> > > >
> > >
> > > Uwe,
> > >
> > > which patches do you refer to?
> > > Can you submit a list of your patches which got no attention (I'm only
> > > interested in the patches, not in discussions you had)
> > >
> > > Markus
> >
> > Hi Markus,
> > a thousands of thanks for your friendly response - very nice! What a
> > pleasure!
> >
> > I do not send in the two patches for one more time. I have sent them in
> so
> > often!
> > If you take a closer look at the mailing list you will easily find them.
> >
> > One is a docu fix, and the other one, causing so much trouble out of
> nothing
> > but Chehab's stubbornness and incompetence, is the one that makes the
> two
> > DST modules
> > deselectable (i. e. DST itself for TwinHan DST and clones plus DST_CA
> for
> > TwinHan cards with CA slot and Pinnacle PCTV SAT cards with CI extension
> for
> > example).
> >
> > Chehab told me some crap about unresolved symbols which never existed as
> > this second patch just runs fine.
> 
> > The compiler errors are the following:
> > WARNING: "dst_ca_attach" [drivers/media/dvb/bt8xx/dvb-bt8xx.ko]
> undefined!
> > WARNING: "dst_attach" [drivers/media/dvb/bt8xx/dvb-bt8xx.ko] undefined!
> > WARNING: "dvb_pll_configure" [drivers/media/dvb/bt8xx/dvb-bt8xx.ko]
> undefined!
> > WARNING: "dvb_pll_lg_tdvs_h06xf" [drivers/media/dvb/bt8xx/dvb-bt8xx.ko]
> undefined!
> 
> > WARNING:
> /lib/modules/2.6.19-rc5/kernel/drivers/media/dvb/bt8xx/dvb-bt8xx.ko needs unknown symbol dst_attach
> > WARNING:
> /lib/modules/2.6.19-rc5/kernel/drivers/media/dvb/bt8xx/dvb-bt8xx.ko needs unknown symbol dst_ca_attach
> > WARNING:
> /lib/modules/2.6.19-rc5/kernel/drivers/media/dvb/bt8xx/dvb-bt8xx.ko needs unknown symbol dvb_pll_lg_tdvs_h06xf
> > WARNING:
> /lib/modules/2.6.19-rc5/kernel/drivers/media/dvb/bt8xx/dvb-bt8xx.ko needs unknown symbol dvb_pll_configure
> 
> I just looked over the patches and Mauro's response shortly, Mauro
> just wrote that your patch leaves undefined symbols. That way Mauro
> won't commit any patches, nevermind if the patch comes from you or
> someone else.
> 
> I'll have a closer look at what your patch causes tonight, afterwards
> I can say more about it.
> If these symbols aren't needed you might insert dummy functions which
> print that the real implementation isn't compiled into the kernel
> (dvb_attach does it that way)
> 
> Some of your mails only contain 10% information about what you really
> want to solve please cut out the private abusive stuff. The people you
> judge here contributed alot during the last years, it probably
> wouldn't even be possible to compile the whole project that easy if
> these people wouldn't have done all that work for everyone.
> 
> 2.6.21 won't be the last kernel out there, the right place to fix that
> problem is the v4l-dvb repository on linuxtv.org first.
> 
> Markus

Hi Markus,
Sure! BUT:

you again state that there ar obviously unresolved symbols
caused by my DST deselection patches.

Why then do I not get any? (And I told this Mauro a thousands of times that I do and did not get any)!
And I even sent him dmesg, config and absolutely everything he needs to
a. prove that my patches are OK
b. get deeper into it

But he simply ignored that, like a thesis repeating wall, some oracle, or some parrot!

Perhaps the relevant part of my 2.6.21.1 config will offer
some answer for this crucial question:

# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_VIDEO_V4L2=y

#
# Video Capture Adapters
#

#
# Video Capture Adapters
#
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TDA9875 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set

#
# Video decoders
#
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA7111 is not set
# CONFIG_VIDEO_SAA7114 is not set
# CONFIG_VIDEO_SAA711X is not set
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_CX25840 is not set

#
# MPEG video encoders
#
# CONFIG_VIDEO_CX2341X is not set

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
# CONFIG_VIDEO_BT848_DVB is not set
# CONFIG_VIDEO_SAA6588 is not set
# CONFIG_VIDEO_BWQCAM is not set
# CONFIG_VIDEO_CQCAM is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set

#
# V4L USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_W9968CF is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set

#
# Radio Adapters
#
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_USB_DSBR is not set

#
# Digital Video Broadcasting Devices
#
CONFIG_DVB=y
CONFIG_DVB_CORE=m
CONFIG_DVB_CORE_ATTACH=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET is not set
# CONFIG_DVB_BUDGET_CI is not set
# CONFIG_DVB_BUDGET_AV is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_CINERGYT2 is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Customise DST support
#
CONFIG_DVB_DST_CUSTOMISE=y
# CONFIG_DVB_DST is not set
# CONFIG_DVB_DST_CA is not set

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_CX24110=m
# CONFIG_DVB_CX24123 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_TDA10086 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
# CONFIG_DVB_OR51211 is not set
# CONFIG_DVB_OR51132 is not set
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set

#
# Tuners/PLL support
#
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TUNER_QT1010 is not set
# CONFIG_DVB_TUNER_MT2060 is not set
# CONFIG_DVB_TUNER_LGH06XF is not set

I swear I did not even produce ONE unresolved symbol!
I use cx24110, I use CONFIG_DVB_FE_CUSTOMISE=y, I use CONFIG_DVB_BT8XX=m,
I use CONFIG_DVB_CORE_ATTACH=y, AND I use my self built additions like

CONFIG_DVB_DST_CUSTOMISE=y
# CONFIG_DVB_DST is not set
# CONFIG_DVB_DST_CA is not set

And I swear that this dvb-pll.c is completely obsolete for this scenario!
For that reason (old variant):
# CONFIG_DVB_TUNER_LGH06XF is not set

And this old variant was NOT done by Trent Piepho, it was NOT done by Andrew Quincey,
but it was produced by Michael Krufky himself, and I was very thankful for that and still am!

So where the hell do these unresolved symbols come from, if I did not get even ONE????
AND, in so far, how should I correct something whose hidden cause I cannot see, as my
scenario DOES NOT produce any unresolved symbols??

May be your configuration differs from mine, and that is where the pain is!
But please do not waste time if there is no reason for it.

Is it in the end another frontend except the cx24110 whose
activation causes those unresolved symbols?

Are there different frontends in the end except cx24110 that need those dst attachments?

If yes, which frontends are the relevant ones?
See, Markus, either noone knows, or the Manuel Abraham primadonna refuses to answer once again. This is the hopeless situation that I am talking about - incredible!

In so far a very sophisticated team leader who knows about this all in general terms would be a necessity for the personnel @linuxtv.org.

Gerd Knorr was doing that job very fine - I swear I never had any trouble with him! Not even once!
He was communicative, he was technically excellent, he was just incredibly fine!

Now if yes, I always stated that I do not owe a whole bunch of testing cards.

If yes I suppose this whole dvb_attach issue is just another big, buggy and half-boiled chaos.

And why the hell is that dvb-pll.c rollback part of git2 now?
Additionally - with the acknowlegdement of Michael Krufky - incredible!

Cheers and a thousands of thanks for your pain

Uwe

> 
> > I also did not miss any warning lines in the deselection menu that I
> > programmed and I can swear I definitely missed no chance to convince
> Chehab
> > and others that my patches are close to being real perfect! IN VAIN!
> >
> > So, if you do not find my patches on the mailing list or if there are
> any
> > questions as far as what concerns that issue please feel free to ask me
> as I
> > believe that you are really open-minded towards that.
> >
> > Above that I want to confirm the utmost necessity to rip Trent Piepho's
> > regressive work out of 2.6.21-git2 as it is in fact technically the most
> > regressive and reactionary crap that I ever have seen......
> >
> > So please Linus - rip that crap out of 2.6.21-git2. And if you do see
> > questions what parts you need to rip out, please feel free to ask me....
> >
> > Cheers
> > Uwe
> >
> > --
> > "Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
> > Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
> >
> 
> 
> -- 
> Markus Rechberger

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
