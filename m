Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXCKUxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXCKUxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXCKUxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:53:19 -0400
Received: from www17.your-server.de ([213.133.104.17]:4539 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXCKUxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:53:18 -0400
Message-ID: <45F46B65.8070207@m3y3r.de>
Date: Sun, 11 Mar 2007 21:49:41 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: SwSusp to disk doesn't work - Try 2
References: <45F44599.3060508@m3y3r.de> <200703112132.32753.rjw@sisk.pl> <45F46660.4010102@m3y3r.de> <200703112145.10767.rjw@sisk.pl>
In-Reply-To: <200703112145.10767.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
>
> Okay, but could you please compile the kernel without NO_HZ and retest?
>
>   


Sure.
But i get the same behaviour:

Mar 11 21:42:07 [kernel] processor ACPI0007:00: freeze
Mar 11 21:42:07 [kernel] button button_power:00: freeze
Mar 11 21:42:07 [kernel] acpi acpi_system:00: freeze
Mar 11 21:42:07 [kernel] Disabling non-boot CPUs ...
Mar 11 21:42:07 [kernel] kvm: disabling virtualization on CPU1
Mar 11 21:42:07 [kernel] synchronize_rcu: Befor wait
Mar 11 21:42:07 [kernel] synchronize_rcu: After wait
Mar 11 21:42:07 [kernel] CPU 1 is now offline
Mar 11 21:42:07 [kernel] SMP alternatives: switching to UP code
Mar 11 21:42:07 [kernel] PM: Removing info for No Bus:cpu1
Mar 11 21:42:07 [kernel] PM: Removing info for No Bus:msr1
Mar 11 21:42:07 [kernel] CPU1 is down
Mar 11 21:42:07 [kernel] swsusp debug: Waiting for 5 seconds.
Mar 11 21:42:07 [kernel] Enabling non-boot CPUs ...
Mar 11 21:42:07 [kernel] _cpu_up: before notifier CPU_UP_PREPARE.
Mar 11 21:42:07 [kernel] migration_call: Hi!
Mar 11 21:42:07 [kernel] rcu_cpu_notify: Hi!
Mar 11 21:42:07 [kernel] timer_cpu_notify: Hi!
Mar 11 21:42:07 [kernel] hrtimer_cpu_notify: Hi!
Mar 11 21:42:07 [kernel] cpu_callback: Hi!
Mar 11 21:42:07 [kernel] synchronize_rcu: Befor wait


----> Hang
Why does this message appear two times?

                - Last output repeated twice -
Mar 11 21:42:07 [kernel] synchronize_rcu: After wait
Mar 11 21:42:07 [kernel] workqueue_cpu_callback: Hi!
Mar 11 21:42:07 [kernel] topology_cpu_callback: Hi!
Mar 11 21:42:07 [kernel] _cpu_up: after notifier CPU_UP_PREPARE.
Mar 11 21:42:07 [kernel] SMP alternatives: switching to SMP code
Mar 11 21:42:07 [kernel] Booting processor 1/1 eip 3000
Mar 11 21:42:07 [kernel] CPU 1 irqstacks, hard=c0387000 soft=c0385000
Mar 11 21:42:07 [kernel] Initializing CPU#1
Mar 11 21:42:07 [kernel] Calibrating delay using timer specific 
routine.. 3662.97 BogoMIPS (lpj=6102352)
Mar 11 21:42:07 [kernel] CPU: After generic identify, caps: bfe9fbff 
00100000 00000000 00000000 0000c1a9 00000000 00000000
Mar 11 21:42:07 [kernel] monitor/mwait feature present.
Mar 11 21:42:07 [kernel] CPU: L1 I cache: 32K, L1 D cache: 32K
Mar 11 21:42:07 [kernel] CPU: L2 cache: 2048K
Mar 11 21:42:07 [kernel] CPU: Physical Processor ID: 0
Mar 11 21:42:07 [kernel] CPU: Processor Core ID: 1
Mar 11 21:42:07 [kernel] CPU: After all inits, caps: bfe9fbff 00100000 
00000000 00002940 0000c1a9 00000000 00000000
Mar 11 21:42:07 [kernel] CPU1: Intel Genuine Intel(R) CPU           
T2400  @ 1.83GHz stepping 08
Mar 11 21:42:07 [kernel] synchronize_rcu: After wait
Mar 11 21:42:07 [kernel] _cpu_up: after __cpu_up
Mar 11 21:42:07 [kernel] _cpu_up: before notifier CPU_ONLINE.

