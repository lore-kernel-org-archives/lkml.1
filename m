Return-Path: <linux-kernel-owner+w=401wt.eu-S1760636AbYCUSv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760636AbYCUSv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbYCUSvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:51:47 -0400
Received: from www.tglx.de ([62.245.132.106]:60668 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbYCUSvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:51:46 -0400
Date: Fri, 21 Mar 2008 19:49:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <crazy@frugalware.org>
cc: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <47E3FA4F.9060509@frugalware.org>
Message-ID: <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de>
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com>
 <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Gabriel C wrote:
> >> Also, can you please reapply the reverted clocksource patch ? I have
> >> the feeling that the acpi_pm one was the real problem which was
> >> triggered the modfied watchdog.
> > 
> > Sure I can , will do so in some minutes and let you know.
> 
> It took a bit longer sorry but I have more infos now.
> 
> The acpi_pm was not related to that I still get the problem.
> 
> Of course I still can try to find the commit which magically fixed acpi_pm if you really want.

Just if you are really bored. :) I would have asked if it had fixed
the TSC issue.
 
> It seems like it breaks only when you enable HT and only on 2 socket motherboards. 
> ( at least the ones I own , I know is old hardware but worked fine for me )

Hmm. I wonder why a dual socket board survives the initial sync test.
 
> Also disabling the second CPU and enabling HT works , enabling both
> CPUs and disabling HT works , booting with enabled HT and both CPUs
> but maxcpus=2 also works , booting with 2 CPUs and HT on breaks ,
> booting with both CPUs HT on but maxcpus=3 breaks also.
> 
> Also I have another dual motherboard here 604 socket with 2 2,4 GHz
> Xeon's.  The motherboard has the storage controller somewhat broken
> but for a quick test it is still good :) and I see the same thing.
> 
> Does that make any sense ?

Not really. Can you please revert the reverted revert again and run

http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

on your machine with all CPUs and HT enabled ?

Thanks,
	tglx
