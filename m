Return-Path: <linux-kernel-owner+w=401wt.eu-S1030580AbXC2Scv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030580AbXC2Scv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXC2Scv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:32:51 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2010 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030650AbXC2Scu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:32:50 -0400
From: Mariusz =?utf-8?q?Koz=C5=82owski?= <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-rc5-mm1
Date: Thu, 29 Mar 2007 20:45:12 +0200
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Matt Mackall <mpm@selenic.com>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <200703292001.41255.m.kozlowski@tuxland.pl> <20070329105233.31adb052.akpm@linux-foundation.org>
In-Reply-To: <20070329105233.31adb052.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703292045.13140.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > Ok. CONGIG_NO_HZ=n and uptime ~12 hours, netconsole loaded, and no hangs
> > ... until I moved my laptop. The same scenario happened yesterday during the
> > last hang. I started playing and repeating some steps which I naturally do when
> > I move my laptop.
> > 
> > An hour later I came to this -> steps to hang 2.6.21-rc5-mm1 on my laptop:

Ok. Failed to mention one important step -> alt-sysrq-7. With alt-sysrq-{1...6}
it does not hang.

1. boot the system and login as root
2. load netconsole (insmod netconole.ko netconsole=blah... blah...)
3. issue alt-sysrq-7
4. unplug the cable (link goes down)
5. system is frozen until forced to reboot

> > This is verified and repeatable _every_ single time I tried. Unfortunately
> > the last thing seen on the screen before system is frozen is 'eth0: link down'.
> > So my guess is that when hunting for hangs I found something else that can hang
> > my laptop (netconsole that is).
> 
> fix-sysfs-reclaim-crash.patch is known-bad.  Did you try reverting that?

Yes, just tested it. Sorry. It doesn't change anything.

Regards,

	Mariusz Kozlowski
