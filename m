Return-Path: <linux-kernel-owner+w=401wt.eu-S1757777AbYHaTKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbYHaTKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 15:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYHaTKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 15:10:09 -0400
Received: from web82104.mail.mud.yahoo.com ([209.191.84.217]:35841 "HELO
	web82104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755792AbYHaTKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 15:10:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=Lq+82FCu/194ac9Fov6i91nXhiCPRUsCDK6I1x9CbEpDWh8ICN3VvjCScbKl2QwWyyFAL4pfp3JJclavJtiQgj1eAc4hwy11SeI9SETV4cNCgRV0qioOxys8xEHDc0zre1vdX+kBJMs9b/tfnIDs7z7jxHXyE9d3CQHORqw/s38=;
X-YMail-OSG: 6IX2jR0VM1k_Fm_x1yNwFCmxLyNLW4MRzVpgA6mk3Ge1GSC9f_W7x023aAUnsSQ0eGdvH2SpSwC1p080dyJQdIwpn1AUCijdxmCytrionbrP5bq_knBvlZl5y49ghQg-
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.218.2
Date: Sun, 31 Aug 2008 12:10:07 -0700 (PDT)
From: David Witbrodt <dawitbro@sbcglobal.net>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v2
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <308581.79965.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> David Witbrodt :
> [...]
> > ===== SETTERM OUTPUT =====
> > Clocksource tsc unstable (delta = -98677795 ns)
> > NETDEV WATCHDOG: eth0 (r8169): transmit timed out
> > ------------[ cut here ]------------
> > WARNING: at net/sched/sch_generic.c:221 dev_watchdog+0x21e/0x250()
> > Modules linked in: ipv6 cpufreq_userspace pcspkr 8250_pnp 8250 serial_core 
> evdev
> > Pid: 0, comm: swapper Not tainted 2.6.27-rc4.080829.yh-patches-tip #1
> > Call Trace:
> [...]
> >  [] cpu_idle+0x56/0xa0
> > ---[ end trace 28095e4c2b529c2a ]---
> > r8169: eth0: link up
> > ===== END SETTERM OUTPUT =====
> > 
> > Other than this strangeness, everything seems OK with your patches.  This
> > looks like some random networking annoyance to me, not really related to
> > the regression patches, but I'll let better minds be the judge of that.
> 
> Could you enable CONFIG_PRINTK_TIME ?
> 
> Even if the networking driver manages to negotiate the link, this is
> the kind of message which upsets people (myself included :o) ).

Will do.

FYI, that kernel would not reproduce the call trace after several reboots.
I had never seen a trace like that before, and have not seen one since.


DW
