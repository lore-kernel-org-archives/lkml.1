Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbXECLUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbXECLUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbXECLUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:20:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:44027 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753736AbXECLUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:20:16 -0400
Cc: linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset="utf-8"
Date: Thu, 03 May 2007 13:20:13 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <4638C046.1020005@gmail.com>
Message-ID: <20070503112013.272380@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<4636E0E2.5020601@simon.arlott.org.uk>
	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net>
 <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>
 <4638C046.1020005@gmail.com>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
To: Manu Abraham <abraham.manu@gmail.com>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18RLe0A8MkRoZ7R8iubDA5luDm/6JbXoXLV/VHBbV
 Od/cW/J64IrRnOaKNJo7VRjNoYHfEXt2JO9Q== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: PrFcNg4LZCEEcGr0GmwhfPl4IGhpZUaS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Wed, 02 May 2007 20:45:58 +0400
Von: Manu Abraham <abraham.manu@gmail.com>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org
Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical points	about ...)

> Uwe Bugla wrote:
> > -------- Original-Nachricht --------
> > Datum: Wed, 02 May 2007 17:30:32 +0400
> > Von: Manu Abraham <abraham.manu@gmail.com>
> > An: Trent Piepho <xyzzy@speakeasy.org>
> > CC: Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing list
> <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org, Jan Engelhardt
> <jengelh@linux01.gwdg.de>, helge.hafting@aitel.hist.no,
> akpm@linux-foundation.org, Linux DVB <linux-dvb@linuxtv.org>
> > Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was:
> Critical	points	about ...)
> > 
> >> Trent Piepho wrote:
> >>> On Tue, 1 May 2007, Simon Arlott wrote:
> >>>> On 30/04/07 22:17, Markus Rechberger wrote:
> >>>>> From my side I do not see any problem with that patch, if someone
> else
> >>>>> has a problem with it please state out the reason.
> >>>> I have no problem with the patch since it has nothing to do with my
> DVB
> >>>> card but you're only encouraging Uwe to be abusive since it seems to
> >>>> help get him what he wants:
> >>> I've been aware of the problem with dst not fully using the dvb
> >> customization
> >>> systems(*) for a long time.  It came up when dvb_attach() et al were
> >> first
> >>> being integrated, well before any rejected patches or strongly worded
> >> emails
> >>> or whatever from certain people that I'm aware of.
> >>>
> >> Well, your understanding of the device is quite limited and hence your
> >> comments and patches.
> >>
> >> The DST as it refers to is an embedded system a x86 Compatible RISC
> core
> >> [1] running at 20Mhz with 4MB Flash and 1MB RAM. The device has it's
> own
> >> IO and 2 DMA channels. What we have is a PQFP device
> >>
> >> This is the case in most cases. On some cheaper cards the embedded
> >> system is replaced by an 8 bit host microcontroller, to cut down costs
> >> where all the features are not required for a specific model
> >>
> >> Additionally this embedded system has a fast shovelling engine for the
> >> MPEG2 TS routing in between the
> >> This embedded system is connected to an actual
> >> (1) DVB frontend [2]
> >> (2) DVB CA interface [3]
> >> (3) Analog tuner
> >> (4) Audio interfaces
> >>
> >> These features are not the characteristics of a DVB Frontend. Here
> there
> >> is a DVB frontend like the normal ones which is hidden behind another
> >> pseudo bridge (So you don't have *any* access to the frontend at large)
> >>
> >> It is not necessary that *all* the dst cards (there are around ~15
> >> different variants of the same) do have the very same feature set.
> >>
> >> It does support DVB-S/DSS/DVB-C/DVB-T/ATSC depending on the cards. In
> >> fact it is a combo driver supporting the entire devices using a common
> >> command set
> >>
> >> In such a case it has more characteristics of the PCI bridge and in
> fact
> >> heavily tied to it and has it's own advantages.
> >>
> >>> I saw some discussion about dst by Markus, Mauro, and Andrew Morton,
> and
> >> since
> >>> I already know about the issues here, I felt I should post a patch for
> >> them
> >>> any other reasonable developers who might spend time on this.
> >>>
> >> I would think that it would be *extremely* rude for a person to send in
> >> patches for a device that which you don't understand at all, when it is
> >> for limiting the capability of the said device
> > 
> > Hi Manu,
> > now if this is your evalution about it all, then let me tell you that I
> feel deeply sorry about it.
> > 
> > Fact is:
> > Noone ever intended to send in patches limiting the capability of the
> said device (DST): I never did, Trent never did, Markus, Mauro, Andrew and
> others never did...
> > 
> > Instead of this we all have very different knowledge and understanding
> levels, with you obviously being the one with the most elaborate and
> sophisticated level.
> > 
> > So please why, instead of marking other people as "rude" whose solutions
> you do not appreciate at all, don't you just pick up the pratical
> proposals of other persons, even if you do not like them for some reasons, and at
> least try to raise them up to a far more better level?
> > Thus you definitely could avoid a lots of flaming, misunderstanding, and
> other counterproductive things to happen...
> > And this would conform to practising the synergetic principle, wouldn't
> it?
> > 
> > Just one hint to help you: I remember a mail from Johannes in which he
> told me that you started up this whole development thing from a zero level
> some two or three years  ago. And Johannes not forgot to state that in the
> beginning you were nothing but nerving... (now add a smiley behind this,
> please, I'd deeply appreciate you to do).
> > 
> > Above that:
> > 1. Taking part in testing the mm-tree and eliminating horrible bugs in
> it I never experienced but positive and warm compromise solutions in the
> end. Experiencing this is highly enlarging one's own personality.
> > 2. If you start up at zero (like you did once too - see above and ask
> Johannes if you do not remember at all) it is no good start at all if your
> humble effort is being thrown off after the first or second reject. That's
> highly discouraging, and if it happens very often the bad experience remains
> in one's own subjective perception filter.
> 
> 
> i did really start very small during those early stages. Johannes did
> help me a lot in many areas, he gave me a lot of valuable information,
> for which i am thankful to him. The same goes to Ralph Metzler and many
> others who gave me a big hand to bootup. Can't forget Andrew, Marcel et
> all in this regard (I did try to pass on such information to some
> people, they thought i was trying to sabotage their project etc.

Hi Manu,

I think noone ever thought you were trying to sabotage any project.
Perhaps you simply missed to „sell“ your ideas a little bit better on the eloquence level.

Example: During this horrible bt8xx breakdown period (kernels 2.6.13 up to 2.6.17-rc1) it was Edgar who definitely did not have the technically better approach, but „sold“ his thoughts far more transparent, reading more logical.
But in the end it was your approach that ensured the best possible solution in the end, not anybody else's.

 I
> stopped responding publicly as you might have seen. At one point i did
> throw away all DVB development, i did write the same on the #linuxtv IRC
> channel, did send a mail to Johannes too on that) It was just one user
> who got me back again on it, a North American DVB user

I would like to be the second one to encourage you to get back on it, as it is a great pity if such a great profound knowledge just disappears from the surface.

> 
> In many cases it would be very nerving to work on hardware that is
> extremely undocumented.

I know, as I had Email contact to Peter Hettkamp, the author of the cx24110 frontend. He told me about the hindrance policy executed by the companies:

a. Pinnacle never offered free cards for linux driver development
b. Connexant only offers info if you sign a very restrictive paper

Plus, on the other hand, the drivers that are written and published for Windoze are a catastrophe like the whole system itself is a catastrophe.

 Sometimes you will have to wait for weeks for a
> certain person (persons who worked on the chips etc. On top of this
> people who worked on the devices will move away to newer organizations.
> Currently facing the same with another chip) to be free to provide an
> answer for the question. In short requires a lot of patience. On top of
> this when someone flames you in the little time one has.. well, many a
> times i lost my temper, yes.
> 
> Sorry, if i was real bad.

I can accept that as it reads very truthful. But in fact the biggest shame is on me because I started to flame you. So please forgive me for having done this.

When I first saw this cx878 project I had the impression that you were trying to get it done on people's backs without ensuring the continuity of a working driver (speak: a bttv dependent one). This may sound quite absurd, but it's my personally view why this immensely long breakdown period ever happened at all.

IMHO there should be exactly two plans:

a. Trying to improve the existing working concept by making dst, dst_ca, and dvb-pll deselectable in a way that does not cause any Oopses or regressions anyway: There is not much work to be done. Just merge my work on makefile and Kconfig with Trent Piepho's work on the rest.
And if you are not satisfied with that for whatever reason I'd deeply appreciate you to settle down in it and add the necessary code that you personally are missing. Should not be much effort, should it?

b. Trying to finish the bt878 project, which is very close to being real mature (Christoph responded that he does not have any time for it so he personally sees no future for it, which is a pity, but should never be a hindrance not to finish it as it follows the right path).

On the technical layer I noticed that I heard some Pinnacle relais click during testing, but there were some i2c_bus symbols missing during compilation. So I guess those missing symbols are responsible for getting neither picture nor sound.
I do not think that the traditional bttv dependencies are such a high and hopeless hindrance reason that cannot be overcome at all.
We're gonna make it if we stick together.

BUT:
It would be utmost terrible to merge both plans with two different priorities into one. For the moment, plan a is highest priority.
But plan b should not be forgotten anyway.
I can offer testing and documentary work for both plans.

> 
> > 3. When I wrote patches since then I never gave up until there weren't
> any
> > a. fuzz factors
> > b. rejections
> > anymore. Instead I highly tried to put Andrew's "The perfect
> patch"-guidelines into practice. Although this kind of perfection reduces maintainers
> to gatekeepers in some cases - the borders of what is what and who is who
> are highly mutual...
> > 
> > So the basic thing is just:
> > 1. To understand that everyone develops, independent from the knowledge
> and understanding level.
> > 2. To understand that everyone has good ideas at least sometimes,
> independent from knowledge and understanding level.
> > 
> > And, even if you do not want to understand it out of whatever reason, it
> is no fun for any person to sound or act "abusive".
> > We're all just trying to search and find solutions, that's all.
> > 
> > Above that I want to thank you for the theoretical introduction that you
> gave.
> > And I hope it helps after all.
> > But I am still very sad that the cx878 project died the way it died, so
> very close before its maturity to be implied into Mercurial tree. I did my
> best to help, but in the end I nothing but wasted time - and after all, I
> do not remember where the repository resides, after thaddatil.net has been
> down for months now... What a pity!
> 
> No, the cx878 project never died. thadathil.net was hosted at my office.
> When the office moved a bit and some other complications, thadathil.net
> went offline. on top of that, at work i was given additional
> responsibilities for which i was struggling real hard. work with regards
> to DVB i just do it in my spare time, but i try to steal away some time
> >from office work as well.
> 
> Christoph usually used to review all my code as well as some others.
> With the upcoming KDE4, he was working more with kaffeine and had little
> time, himself.
> 
> And as you might be aware i was working with a new delivery system
> DVB-S2. When one works with a new delivery system, the existing API
> proved too restrictive. Then working on which i trampled onto many
> issues (not even referring to the new delivery system, or the issues
> with the demodulator, mind you S2 is a bit complex and can really
> confuse people.) with DVB-CORE itself, which led to another API update
> other than multiproto, the Adapter API extensions. while on this again
> stumbled where advanced operations where performed at the in kernel
> demuxer, not forgetting an additional DSS demuxer is also needed in
> kernel for DSS support.
> 
> With all these and struggling hard with 4 hours sleep, well i couldn't
> take all those flames (More than what you see on the ML's many people
> tend to send private mails for some reason or the other for help.
> Normally i don't reject anyone's request), you can say i was kind of
> worn out. Above all these some developers were very "unfriendly", some
> did mischief (politics) too, which led to a larger rift.

Sounds horrible. I once again deeply regret what I started in the past, but I hope I gave enough hints how we all can learn out of it, including me.
If there is no team chief stepping in between to settle down attacks and ellbow egoisms then I think there is a big gap in the personnel structure of the linuxtv.org developpers team.

> 
> So i chose to remain silent. That's all.
> 
> During this period, Julian was kind enough to provide me hosting for my
> requirements. I will try to get thadathil.net up soon (many people used
> to have firmware downloads from there, also some people had access there
> for hosting test repo's and so on)

That sounds fantastic. So can we continue to put plan b into practice too??

> 
> Well, that was a long rant

I hate the word „rant“ for its negative taste at least in the german translation.
I would rather say it was necessary to state all this.
And I also hat terminologies like „The perfect patch.“
Nothing is perfect. But the stepping forward idea is simply to put some puzzle parts together in an appropriate manner.

I guess the only reason why I flamed Mike Krufky was his rejection of unsigned patches. That was my fault too and I regret what I said about him. So please Mike, if you read this please forgive me.

IMHO a missing signature should not be treated like a fetish.
Also unsigned patches can contain good ideas, can't they?
Sometimes it is just necessary to merge the appropriate puzzle parts.

But, on the other hand I remember having asked Edgar at least five times for what reason he remained so stubborn in the signature question.
I never got back at least one reply on that, for whatever reason....

See, the conflict culture here very often conforms to something like a kindergarden, and I deeply regret that...

Above all I still am very hopeful that we can get back to the technical points to be resolved concerning plan a (optimize the bttv dependent concept for now).

Perhaps we should start another thread on this if everybody can agree.
And if you or anybody else feel that you run out of temper or lose control of whatever reason, just move one step backwards, sleep over it one or two nights, and take a new start then with a cool and calm mind... 

Do I expect too much? Hope I do not!

Yours sincerely

Uwe

P. S.:

A. If you are really interested I can send you my basic puzzle parts in short, opening a new thread on this issue. Just give me a short response if you are interested.

B. If you want to continue the cx878 project please drop me a short note where I can download it to test and enlarge it with my own ideas as good as I can.

Must not be immediately (no sweat please), but I am looking forward to receive a response from you.

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
