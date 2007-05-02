Return-Path: <linux-kernel-owner+w=401wt.eu-S2993517AbXEBQoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993517AbXEBQoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 12:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993519AbXEBQoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 12:44:14 -0400
Received: from hu-out-0506.google.com ([72.14.214.229]:42185 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993517AbXEBQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 12:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NG0rYRLb3s9HEhJjHsDMBzdbVH/8R3fTZ/eImMo10Y3C5D9PYPTMoCaxPWrRkOjaRxQQ1nMiIAIwr/tsSRg0YaF9XaBm0jThK4xSZ8RASuKxHtCq+xLgHmRN28JQ4Q3kTZVRY4EmhCuvJx/0/WdvCAQzqbHsqny4ACbnUwHoo5Q=
Message-ID: <4638BFC9.5090304@gmail.com>
Date: Wed, 02 May 2007 20:43:53 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Uwe Bugla <uwe.bugla@gmx.de>
CC: xyzzy@speakeasy.org, linux-dvb@linuxtv.org, akpm@linux-foundation.org,
       helge.hafting@aitel.hist.no, jengelh@linux01.gwdg.de,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       simon@fire.lp0.eu, mchehab@infradead.org
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points	about ...)
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>	<4636E0E2.5020601@simon.arlott.org.uk>	<Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net> <46389278.1070208@gmail.com> <20070502155125.280320@gmx.net>
In-Reply-To: <20070502155125.280320@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla wrote:
> -------- Original-Nachricht --------
> Datum: Wed, 02 May 2007 17:30:32 +0400
> Von: Manu Abraham <abraham.manu@gmail.com>
> An: Trent Piepho <xyzzy@speakeasy.org>
> CC: Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing list <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org, Jan Engelhardt <jengelh@linux01.gwdg.de>, helge.hafting@aitel.hist.no, akpm@linux-foundation.org, Linux DVB <linux-dvb@linuxtv.org>
> Betreff: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical	points	about ...)
> 
>> Trent Piepho wrote:
>>> On Tue, 1 May 2007, Simon Arlott wrote:
>>>> On 30/04/07 22:17, Markus Rechberger wrote:
>>>>> From my side I do not see any problem with that patch, if someone else
>>>>> has a problem with it please state out the reason.
>>>> I have no problem with the patch since it has nothing to do with my DVB
>>>> card but you're only encouraging Uwe to be abusive since it seems to
>>>> help get him what he wants:
>>> I've been aware of the problem with dst not fully using the dvb
>> customization
>>> systems(*) for a long time.  It came up when dvb_attach() et al were
>> first
>>> being integrated, well before any rejected patches or strongly worded
>> emails
>>> or whatever from certain people that I'm aware of.
>>>
>> Well, your understanding of the device is quite limited and hence your
>> comments and patches.
>>
>> The DST as it refers to is an embedded system a x86 Compatible RISC core
>> [1] running at 20Mhz with 4MB Flash and 1MB RAM. The device has it's own
>> IO and 2 DMA channels. What we have is a PQFP device
>>
>> This is the case in most cases. On some cheaper cards the embedded
>> system is replaced by an 8 bit host microcontroller, to cut down costs
>> where all the features are not required for a specific model
>>
>> Additionally this embedded system has a fast shovelling engine for the
>> MPEG2 TS routing in between the
>> This embedded system is connected to an actual
>> (1) DVB frontend [2]
>> (2) DVB CA interface [3]
>> (3) Analog tuner
>> (4) Audio interfaces
>>
>> These features are not the characteristics of a DVB Frontend. Here there
>> is a DVB frontend like the normal ones which is hidden behind another
>> pseudo bridge (So you don't have *any* access to the frontend at large)
>>
>> It is not necessary that *all* the dst cards (there are around ~15
>> different variants of the same) do have the very same feature set.
>>
>> It does support DVB-S/DSS/DVB-C/DVB-T/ATSC depending on the cards. In
>> fact it is a combo driver supporting the entire devices using a common
>> command set
>>
>> In such a case it has more characteristics of the PCI bridge and in fact
>> heavily tied to it and has it's own advantages.
>>
>>> I saw some discussion about dst by Markus, Mauro, and Andrew Morton, and
>> since
>>> I already know about the issues here, I felt I should post a patch for
>> them
>>> any other reasonable developers who might spend time on this.
>>>
>> I would think that it would be *extremely* rude for a person to send in
>> patches for a device that which you don't understand at all, when it is
>> for limiting the capability of the said device
> 
> Hi Manu,
> now if this is your evalution about it all, then let me tell you that I feel deeply sorry about it.
> 
> Fact is:
> Noone ever intended to send in patches limiting the capability of the said device (DST): I never did, Trent never did, Markus, Mauro, Andrew and others never did...
> 
> Instead of this we all have very different knowledge and understanding levels, with you obviously being the one with the most elaborate and sophisticated level.
> 
> So please why, instead of marking other people as "rude" whose solutions you do not appreciate at all, don't you just pick up the pratical proposals of other persons, even if you do not like them for some reasons, and at least try to raise them up to a far more better level?
> Thus you definitely could avoid a lots of flaming, misunderstanding, and other counterproductive things to happen...
> And this would conform to practising the synergetic principle, wouldn't it?
> 
> Just one hint to help you: I remember a mail from Johannes in which he told me that you started up this whole development thing from a zero level some two or three years  ago. And Johannes not forgot to state that in the beginning you were nothing but nerving... (now add a smiley behind this, please, I'd deeply appreciate you to do).
> 
> Above that:
> 1. Taking part in testing the mm-tree and eliminating horrible bugs in it I never experienced but positive and warm compromise solutions in the end. Experiencing this is highly enlarging one's own personality.
> 2. If you start up at zero (like you did once too - see above and ask Johannes if you do not remember at all) it is no good start at all if your humble effort is being thrown off after the first or second reject. That's highly discouraging, and if it happens very often the bad experience remains in one's own subjective perception filter.


i did really start very small during those early stages. Johannes did
help me a lot in many areas, he gave me a lot of valuable information,
for which i am thankful to him. The same goes to Ralph Metzler and many
others who gave me a big hand to bootup. Can't forget Andrew, Marcel et
all in this regard (I did try to pass on such information to some
people, they thought i was trying to sabotage their project etc. I
stopped responding publicly as you might have seen. At one point i did
throw away all DVB development, i did write the same on the #linuxtv IRC
channel, did send a mail to Johannes too on that) It was just one user
who got me back again on it, a North American DVB user

In many cases it would be very nerving to work on hardware that is
extremely undocumented. Sometimes you will have to wait for weeks for a
certain person (persons who worked on the chips etc. On top of this
people who worked on the devices will move away to newer organizations.
Currently facing the same with another chip) to be free to provide an
answer for the question. In short requires a lot of patience. On top of
this when someone flames you in the little time one has.. well, many a
times i lost my temper, yes.

Sorry, if i was real bad.

> 3. When I wrote patches since then I never gave up until there weren't any
> a. fuzz factors
> b. rejections
> anymore. Instead I highly tried to put Andrew's "The perfect patch"-guidelines into practice. Although this kind of perfection reduces maintainers to gatekeepers in some cases - the borders of what is what and who is who are highly mutual...
> 
> So the basic thing is just:
> 1. To understand that everyone develops, independent from the knowledge and understanding level.
> 2. To understand that everyone has good ideas at least sometimes, independent from knowledge and understanding level.
> 
> And, even if you do not want to understand it out of whatever reason, it is no fun for any person to sound or act "abusive".
> We're all just trying to search and find solutions, that's all.
> 
> Above that I want to thank you for the theoretical introduction that you gave.
> And I hope it helps after all.
> But I am still very sad that the cx878 project died the way it died, so very close before its maturity to be implied into Mercurial tree. I did my best to help, but in the end I nothing but wasted time - and after all, I do not remember where the repository resides, after thaddatil.net has been down for months now... What a pity!

No, the cx878 project never died. thadathil.net was hosted at my office.
When the office moved a bit and some other complications, thadathil.net
went offline. on top of that, at work i was given additional
responsibilities for which i was struggling real hard. work with regards
to DVB i just do it in my spare time, but i try to steal away some time
from office work as well.

Christoph usually used to review all my code as well as some others.
With the upcoming KDE4, he was working more with kaffeine and had little
time, himself.

And as you might be aware i was working with a new delivery system
DVB-S2. When one works with a new delivery system, the existing API
proved too restrictive. Then working on which i trampled onto many
issues (not even referring to the new delivery system, or the issues
with the demodulator, mind you S2 is a bit complex and can really
confuse people.) with DVB-CORE itself, which led to another API update
other than multiproto, the Adapter API extensions. while on this again
stumbled where advanced operations where performed at the in kernel
demuxer, not forgetting an additional DSS demuxer is also needed in
kernel for DSS support.

With all these and struggling hard with 4 hours sleep, well i couldn't
take all those flames (More than what you see on the ML's many people
tend to send private mails for some reason or the other for help.
Normally i don't reject anyone's request), you can say i was kind of
worn out. Above all these some developers were very "unfriendly", some
did mischief (politics) too, which led to a larger rift.

So i chose to remain silent. That's all.

During this period, Julian was kind enough to provide me hosting for my
requirements. I will try to get thadathil.net up soon (many people used
to have firmware downloads from there, also some people had access there
for hosting test repo's and so on)

Well, that was a long rant
