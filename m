Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbYCUQ2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbYCUQ2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYCUQ2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:28:22 -0400
Received: from www.tglx.de ([62.245.132.106]:51940 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYCUQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:28:22 -0400
Date: Fri, 21 Mar 2008 17:26:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <nix.or.die@googlemail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Gabriel C <crazy@frugalware.org>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <47E3D322.1090902@googlemail.com>
Message-ID: <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de>
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Gabriel C wrote:
 
> > still hangs when I boot with clocksource=acpi_pm so that seems to
> > be introduced in a different commit.
> > 
> > I will try to bisect this hang also , most probably on weekend.
> > 
> 
> Correction on this one.
>
> Current git head boots just fine with clocksource=acpi_pm here , I
> just don't know which commit fixed it.

Hmm. Very dubious. I'm a bit afraid of self healing problems. It would
be interesting to find the commit which fixed the acpi_pm timer
problem unvoluntary.

Also, can you please reapply the reverted clocksource patch ? I have
the feeling that the acpi_pm one was the real problem which was
triggered the modfied watchdog.

Thanks,

	tglx
