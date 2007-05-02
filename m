Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbXEBPvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbXEBPvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXEBPvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:51:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:57001 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755245AbXEBPv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:51:29 -0400
Cc: linux-dvb@linuxtv.org, akpm@linux-foundation.org,
       helge.hafting@aitel.hist.no, jengelh@linux01.gwdg.de,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       simon@fire.lp0.eu, mchehab@infradead.org
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 02 May 2007 17:51:25 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <46389278.1070208@gmail.com>
Message-ID: <20070502155125.280320@gmx.net>
MIME-Version: 1.0
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
	<4636E0E2.5020601@simon.arlott.org.uk>
	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net>
 <46389278.1070208@gmail.com>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
	points	about ...)
To: Manu Abraham <abraham.manu@gmail.com>, xyzzy@speakeasy.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1/zwCBIQNvzFMRm8E9sF1+xJjxKkq2pH3Mg7S5sF6
 iL1fCQvd/1jlcZp7lFQr1ZcgMU9a8vfpbhmA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: KvdyAcgKa2AoSWC4SHQyJyE6OWhhascI
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Wed, 02 May 2007 17:30:32 +0400
Von: Manu Abraham <abraham.manu@gmail.com>
An: Trent Piepho <xyzzy@speakeasy.org>
CC: Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing list <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org, Jan Engelhardt <jengelh@linux01.gwdg.de>, helge.hafting@aitel.hist.no, akpm@linux-foundation.org, Linux DVB <linux-dvb@linuxtv.org>
Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical	points	about ...)

> Trent Piepho wrote:
> > On Tue, 1 May 2007, Simon Arlott wrote:
> >> On 30/04/07 22:17, Markus Rechberger wrote:
> >>> From my side I do not see any problem with that patch, if someone else
> >>> has a problem with it please state out the reason.
> >> I have no problem with the patch since it has nothing to do with my DVB
> >> card but you're only encouraging Uwe to be abusive since it seems to
> >> help get him what he wants:
> > 
> > I've been aware of the problem with dst not fully using the dvb
> customization
> > systems(*) for a long time.  It came up when dvb_attach() et al were
> first
> > being integrated, well before any rejected patches or strongly worded
> emails
> > or whatever from certain people that I'm aware of.
> > 
> 
> Well, your understanding of the device is quite limited and hence your
> comments and patches.
> 
> The DST as it refers to is an embedded system a x86 Compatible RISC core
> [1] running at 20Mhz with 4MB Flash and 1MB RAM. The device has it's own
> IO and 2 DMA channels. What we have is a PQFP device
> 
> This is the case in most cases. On some cheaper cards the embedded
> system is replaced by an 8 bit host microcontroller, to cut down costs
> where all the features are not required for a specific model
> 
> Additionally this embedded system has a fast shovelling engine for the
> MPEG2 TS routing in between the
> This embedded system is connected to an actual
> (1) DVB frontend [2]
> (2) DVB CA interface [3]
> (3) Analog tuner
> (4) Audio interfaces
> 
> These features are not the characteristics of a DVB Frontend. Here there
> is a DVB frontend like the normal ones which is hidden behind another
> pseudo bridge (So you don't have *any* access to the frontend at large)
> 
> It is not necessary that *all* the dst cards (there are around ~15
> different variants of the same) do have the very same feature set.
> 
> It does support DVB-S/DSS/DVB-C/DVB-T/ATSC depending on the cards. In
> fact it is a combo driver supporting the entire devices using a common
> command set
> 
> In such a case it has more characteristics of the PCI bridge and in fact
> heavily tied to it and has it's own advantages.
> 
> > I saw some discussion about dst by Markus, Mauro, and Andrew Morton, and
> since
> > I already know about the issues here, I felt I should post a patch for
> them
> > any other reasonable developers who might spend time on this.
> > 
> 
> I would think that it would be *extremely* rude for a person to send in
> patches for a device that which you don't understand at all, when it is
> for limiting the capability of the said device

Hi Manu,
now if this is your evalution about it all, then let me tell you that I feel deeply sorry about it.

Fact is:
Noone ever intended to send in patches limiting the capability of the said device (DST): I never did, Trent never did, Markus, Mauro, Andrew and others never did...

Instead of this we all have very different knowledge and understanding levels, with you obviously being the one with the most elaborate and sophisticated level.

So please why, instead of marking other people as "rude" whose solutions you do not appreciate at all, don't you just pick up the pratical proposals of other persons, even if you do not like them for some reasons, and at least try to raise them up to a far more better level?
Thus you definitely could avoid a lots of flaming, misunderstanding, and other counterproductive things to happen...
And this would conform to practising the synergetic principle, wouldn't it?

Just one hint to help you: I remember a mail from Johannes in which he told me that you started up this whole development thing from a zero level some two or three years  ago. And Johannes not forgot to state that in the beginning you were nothing but nerving... (now add a smiley behind this, please, I'd deeply appreciate you to do).

Above that:
1. Taking part in testing the mm-tree and eliminating horrible bugs in it I never experienced but positive and warm compromise solutions in the end. Experiencing this is highly enlarging one's own personality.
2. If you start up at zero (like you did once too - see above and ask Johannes if you do not remember at all) it is no good start at all if your humble effort is being thrown off after the first or second reject. That's highly discouraging, and if it happens very often the bad experience remains in one's own subjective perception filter.
3. When I wrote patches since then I never gave up until there weren't any
a. fuzz factors
b. rejections
anymore. Instead I highly tried to put Andrew's "The perfect patch"-guidelines into practice. Although this kind of perfection reduces maintainers to gatekeepers in some cases - the borders of what is what and who is who are highly mutual...

So the basic thing is just:
1. To understand that everyone develops, independent from the knowledge and understanding level.
2. To understand that everyone has good ideas at least sometimes, independent from knowledge and understanding level.

And, even if you do not want to understand it out of whatever reason, it is no fun for any person to sound or act "abusive".
We're all just trying to search and find solutions, that's all.

Above that I want to thank you for the theoretical introduction that you gave.
And I hope it helps after all.
But I am still very sad that the cx878 project died the way it died, so very close before its maturity to be implied into Mercurial tree. I did my best to help, but in the end I nothing but wasted time - and after all, I do not remember where the repository resides, after thaddatil.net has been down for months now... What a pity!

Cheers
Uwe

> 
> > If there is an abusive person, I'm not going to let it affect my
> behavior.
> > You lose if you let them influence your decisions one way, or influence
> them
> > another way.
> > 
> > 
> > (*) There are two customization/dependency control systems in DVB.  One
> is
> > dvb_attach(), the other is DVB_FE_CUSTOMISE.  They are not two entirely
> > separate systems, but overlap in their design a great deal.
> > 
> 
> 
> Here we have the attach method attaching different objects, but
> basically it can be handled for the frontend devices only (and that too
> that share a very common trait, in this case, frontends are coupled
> using the i2c bus) and not for other devices. Situation changes when you
> use another interface such as SPI, where the interface is not well
> defined.
> 
> In the DVB OO concept we have, where the objects are at different
> levels, the basic concept is that an object is indeed a smaller subset,
> depending on the level that which it pertains to. In such a case the
> frontend is limited to do just frontend related operations. There could
> be other ways that things can be done maybe the DVB API can be redone to
> have all DVB operations through the frontend alone. But that is not at
> all decent way of doing it.
> 
> 
> > The significant part, common to both, is the overall design of the
> driver
> > framework.  DVB uses what I would describe as an object oriented system.
>  A
> > driver for a certain type of hardware exports a single attach function,
> which
> > returns an object for one instance of that hardware.  All control of
> that
> > hardware is done via methods defined in this object.  There is typical
> > hierarchy, where an 'adapter' object will contain a 'frontend' object
> which
> > will contain a 'tuner' object.  Of course hardware designers are not
> > constrained by the software frameworks we create, so sometimes it's more
> > complex (e.g., dst).
> 
> It is a bit more complex than you think. You can imagine the entire
> DVB-CORE along with proprietory vendor specific tuning algorithms (on
> all devices, specific to the hardware onbaord. Algorithms do change from
> slight change of hardware such as demodulators and or CA interface
> stacks) on CA devices it has an onboard EN50221 CA stack from SCM [4]
> called the Sunplus CI stack. On Hybrid DST devices they do feature in
> analog core support in there as well as Audio too on some cards.
> 
> It is not a constraint as what you might think, as the DST is complete
> hardware solution of the interfaces that you are talking about. (There
> are 2 approaches, (1) do everything in hardware (2) do everything in
> software) there are merits and demerits equally to both the approaches.
> 
> So here we are talking about 3 different subsystems DVB, V4L and ALSA.
> Currently the DST supports *only* DVB and that too it is limited. There
> is more to DVB than what you see in the DST as of now.
> Support for multiple delivery systems do not exists as of now (requires
> the multiproto DVB API patches)
> 
> With these said, i wouldn't want to close the window for the dst to be a
> DVB frontend alone, as that's what you are trying to do
> 
> > This design means the actual hard link between different drivers is
> limited to
> > each driver's single attach function (**).  By breaking this one link,
> we can
> > control which drivers must be loaded or linked to only those necessary
> or
> > wanted.  dvb_attach() and DVB_FE_CUSTOMISE are two different ways of
> > controlling these links.
> 
> dvb_attach will have to go away for the DST. It doesn't work for the
> mentioned reasons that it is just pushing the device to a corner as a
> DVB frontend whereas it is not a DVB Frontend at all.
> 
> [1] R8820 CPU core
> http://jusst.de/manu/misc/R8820-F19.pdf
> 
> [2] DVB Fontend
> A DVB Frontend consists of a Demodulator
> (http://www.linuxtv.org/wiki/index.php/Demodulator) and a tuner
> 
> [3] DVB CA interface
> A CA Interface consists of a CI slot
> (http://www.linuxtv.org/wiki/index.php/Common_Interface) and a
> CA module (http://www.linuxtv.org/wiki/index.php/CAM)
> 
> [4] http://www.scmmicro.com/
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
