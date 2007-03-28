Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXC1Ujb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXC1Ujb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbXC1Ujb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:39:31 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3281 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXC1Uja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:39:30 -0400
From: Mariusz =?utf-8?q?Koz=C5=82owski?= <m.kozlowski@tuxland.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc5-mm1
Date: Wed, 28 Mar 2007 22:49:47 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <20070328130234.c0a23572.akpm@linux-foundation.org> <20070328202542.GS16477@stusta.de>
In-Reply-To: <20070328202542.GS16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703282249.48130.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > 	I run 2.6.21-rc4-mm1 with no hangs for a week.
> > > Then when 2.6.21-rc5-mm1 showed up so I switched to it. Unfortunately
> > > today my laptop hunged twice in a similar way as described here:
> > > 
> > > http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
> > 
> > It's not good that we went backwards between those two releases.
> > 
> > > The difference is that it happened when I closed the lid in my laptop.
> > > When reopend it the box was frozen (ACPI?). Again disk I/O was dead
> > > so nothing was found in syslog.
> > 
> > Adrian, does this look like any of the bugs whcih you're monitoring?
> >...
> 
> Is it also present in 2.6.21-rc5?

Don't know. I usualy test -mm series. Will test tommorow and let you know
after some reasonable uptime.

> Is it also present with CONFIG_NO_HZ=n?

Don't know. Did not try recently. Will let you know.

It takes time as these hangs are not easy to trigger. With 2.6.21-rc2-mm1
it was easy -> push the system and watch it die in minutes. With
2.6.21-rc5-mm1 it takes hours (3 hangs in ~15 hours) and not sure how to
trigger it. It just happens from time to time.

> cu
> Adrian

Regards,

	Mariusz Kozlowski
