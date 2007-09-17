Return-Path: <linux-kernel-owner+w=401wt.eu-S1752737AbXIQFdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbXIQFdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 01:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXIQFda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 01:33:30 -0400
Received: from keil-draco.com ([216.193.185.50]:50240 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbXIQFd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 01:33:28 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Can E. Acar" <can.acar@pro-g.com.tr>
Subject: Re: Wasting our Freedom
Date: Mon, 17 Sep 2007 01:33:16 -0400
User-Agent: KMail/1.9.6
Cc: misc@openbsd.org, linux-kernel@vger.kernel.org,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <200709161632.21927.dhazelton@enter.net> <46EDEDB9.1000104@pro-g.com.tr>
In-Reply-To: <46EDEDB9.1000104@pro-g.com.tr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709170133.17025.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 September 2007 23:00:09 Can E. Acar wrote:
> Daniel Hazelton wrote:
> > On Sunday 16 September 2007 14:48:47 Can E. Acar wrote:
>
> [snip]
>
> >> First, these developers got questionable advice from senior Linux kernel
> >> developers, and SLFC (which is closely related to FSF) in the process.
> >
> > IIRC, the advice was "Yes, it is legal to choose to follow only one of
> > multiple offered licenses on a project" - nothing else. They looked at
> > the patches and said "Wait, you've changed the license on files that
> > aren't under a dual license."
> >
> > Hence, no problems here - no questionable advice only.
>
> The replies suggest that some (most?) people are not aware of the
> recent developments, and that it is a dual licensing issue.

Look at what I replied to and then thank me for replying to the text in 
question. Or is the fact that I was responding to -
> >> First, these developers got questionable advice from senior Linux kernel
> >> developers, and SLFC (which is closely related to FSF) in the process.
- somehow beyond your comprehension?

> This has very little to do with dual licensing right now,
> there has been other developments, more "advice" from SLFC.

And I have seen absolutely none of said "advice".

> The code in question is Reyk's open source HAL work.
> I want to emphasize. This work was NOT ever dual licensed.

And that was only in question *PRIOR* to the review and rejection of the 
patches in question. Comprende ?

> Furthermore, since it is compatible with the binary HAL from
> Atheros, the interface is fixed and the same both in Linux and
> *BSD.  So, even the latst code divergence arguments do not
> apply here. The improvements to this piece of code improve
> the Open Source Atheros support, and is important for both
> Linux and BSD.

Doubtful. If I wrote a HAL implementation from scratch using Reyk's code as a 
reference only would that make my bottom-up rewrite a derivative?

If you think it would, then you need to stop talking and start listening. Just 
because the code needs to provide a specific interface does not mean that any 
specific persons implementation is a derivative of another. This simple fact 
is key - because if that fact wasn't true then the original, purely binary 
HAL that was/is in FreeBSD would be illegal, as would Reyk's code.

> Theo summarized the latest situation here, some days ago:
>
>   http://marc.info/?l=openbsd-misc&m=118963284332223&w=2
>
> and here is a very brief summary:
>
>   http://marc.info/?l=openbsd-misc&m=118965266709012&w=2
>
> If you really want to know the latest situation, please read these
> links, and think about it.

No need. Here are the facts:
1) People have come to the Linux Kernel ML and complained about a set of 
patches that were never accepted. 
2) Theo has accused a Kernel developer of telling people to break the law.
3) People show up complaining again, apparently about the same patches.
4) One of them points out that the MadWifi developers have taken the broken 
patches
5) Several people on LKML say "So go be a troll there, leave us alone"
6) The original people, and more, start with claims that the Linux Kernel 
developers should "police" the "GNU/FSF/GPL Community"

And now you come here saying that people don't understand the situation.

Go look at the first two links in Theo's mails, which you linked to. Are they 
to kernel.org git repo's? Is either of them for the "linux-wireless-2.6" git 
repo? 

The answer to both is "No" - they are to MadWifi - a system which is developed 
separate from the Linux Kernel and not discussed here.

The other two links are to a git repo that hasn't been included in the Linux 
Kernel, but probably will be, since it doesn't violate anyones copyright. Is 
Theo happy? No. Because the two people that ported to code to work in Linux 
have added themselves as holding copyrights to portions of the code.

"Those files are still invalidly being distributed -- Nick and Jiri did
not proveably do enough original work to earn copyright on a
derivative work, since their work is just an adaptation."

Now think about it - there are files that they have modified - in some cases 
this was apparently quite a bit of work. Yet they can't place their own 
copyrights on the code because Theo thinks it all is "Just an Adaptation" ?

Think about this: Linux runs on numerous hardware platforms. For each platform 
there is a "port" - and "adaptation" of the code to make the kernel capable 
of running as fast and as stably on the new platform as the original 
supported one. Each one of those "ports" is an "adaptation" of existing code. 
By Theo's reckoning - judging from the statement I've quoted - none of them 
are worthy of a copyright, because they are "Just an adaptation".

For instance, compare src/sys/dev/ic/ar5xxx.h to ath5k.h (they appear to be 
the same file) - there was a *LOT* of work done in this file. I truthfully 
can't tell how much of the original remains and how much has been rewritten 
or split out. But from the amount of work I can see in just *ONE* of the 
files, I can find no reason for anyone to complain that the people that did 
the work have "illegally" added themselves as copyright holders.

> Do you believe re-arranging code, renaming functions, splitting code
> to multiple files, adding some adaptation code is original enough
> to be a derivative work and deserve its own copyright?

No. But you apparently haven't looked at the code yourself. If you had you'd 
see that a lot more than that was done - I haven't given the code a complete 
review myself, but from what I have seen it isn't just a port.

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
