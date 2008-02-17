Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbYBQEJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbYBQEJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 23:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYBQEJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 23:09:45 -0500
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:40579
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbYBQEJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 23:09:45 -0500
X-Authority-Analysis: v=1.0 c=1 a=TEGKNp2qDdgA:10 a=-OlqAyLnqZn_GlqvNswA:9
 a=SkjHRjF2a_BR8Nv6wMLQLVaJdUAA:4 a=uv1ck3d6JtEA:10
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: elendil@planet.nl, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz>
References: <1203123219.6176.36.camel@popeye>
	 <Pine.LNX.4.64.0802161202430.7699@twin.jikos.cz>
	 <1203163503.6124.5.camel@popeye>
	 <Pine.LNX.4.64.0802161907200.30955@jikos.suse.cz>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 22:09:32 -0600
Message-Id: <1203221372.6124.29.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri - 

This is just to confirm that I have been running all day on a kernel
built with CONFIG_GROUP_SCHED turned 'off' and have not seen the problem
with my keyboard (I never noticed a problem with the mouse as others
have)

At slack moments through the day I have taken the oppertunity to perform
7 boots and could not recreate the failure (see my previous note which
has some lame speculation that the conditions for the failure are seeded
at boot time)

If there is anything else you would like to have performed in an attempt
to further isolate this issue I will try my best to provide it.  This
includes going back to a 2.6.25-rc2 kernel with CONFIG_GROUP_SCHED
turned 'on' if you think that further confirmation of the problem is
required or would be useful. 

Once again, thank you for taking the lead on this issue.

Chris




On Sat, 2008-02-16 at 19:08 +0100, Jiri Kosina wrote:
> [ Peter and Ingo added to CC, as this is apparently another instance of 
>   CONFIG_GROUP_SCHED causing mouse/keyboard misbehavior ]
> 
> Thanks for testing, Chris.
> 
> On Sat, 16 Feb 2008, Chris Holvenstot wrote:
> 
> > Jiri - 
> > 
> > 
> > Sorry for the delay in getting this information back to you. I am now up
> > and running on 2.6.25-rc2 with CONFIG_GROUP_SCHED not set (and for the
> > record, I did NOT use the nohpet directive when booting)
> > 
> > 
> > A copy of the dot-config file from this build has been inserted below. 
> > 
> > 
> > So far everything is working nicely with CONFIG_GROUP_SCHED not set.
> > However I have one observation to make, and I am very likely missing
> > something here, is that over the past few days while I have been trying
> > to isolate a broke / not broke point with git bisect it would seem that
> > the conditions which lead to the repeating key failure are seeded at the
> > time of the boot.
> > 
> > 
> > By this I mean that given a specific kernel configuration I can boot it
> > 'x' number of times - out of all those boot cycles I may get one
> > instance of the failure. The rest of the time it works fine.
> > 
> > 
> > On those occasions when I do get the repeating key failure it would
> > appear that the failure lives for the lifespan of the boot. Twice now
> > when I have had the failure I have tried restarting X to see if it
> > clears, but so far I have not had any luck with that.
> > 
> > 
> > I have compared the dmesg output from a good boot to that of a boot
> > where I see the repeating key issue and except for the expected minor
> > differences in the timestamps nothing jumps out at me.
> > 
> > 
> > I built the kernel you requested with the '-j2' option to load up the
> > CPU - I thought that the suggestion made earlier by someone else about
> > this failure happening while the CPU was loaded had some merit - it was
> > one factor I did not take into consideration during my efforts and might
> > explain why I was getting inconsistent results. 
> > 
> > 
> > However, even though both cores were running along at nearly 100% during
> > this build, I did not see the problem. At this point I am about ready to
> > select a previously unused section of wall to bang my head against.
> > 
> > 
> > Thank you for your continued support - 
> > 
> > 
> > Chris
> > 


