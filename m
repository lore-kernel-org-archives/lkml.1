Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXCKUIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXCKUIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbXCKUIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:08:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:4253 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbXCKUIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:08:11 -0400
Message-ID: <45F460CC.60001@m3y3r.de>
Date: Sun, 11 Mar 2007 21:04:28 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Milan Broz <mbroz@redhat.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: SwSusp to disk doesn't work - Try 2
References: <45F44599.3060508@m3y3r.de> <45F452A2.2050009@redhat.com> <45F4557A.9010203@m3y3r.de> <200703112050.16284.rjw@sisk.pl>
In-Reply-To: <200703112050.16284.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry the systems hangs here:

Mar 11 20:55:46 [kernel] CPU 1 is now offline
Mar 11 20:55:46 [kernel] SMP alternatives: switching to UP code
Mar 11 20:55:46 [kernel] PM: Removing info for No Bus:cpu1
Mar 11 20:55:46 [kernel] PM: Removing info for No Bus:msr1
Mar 11 20:55:46 [kernel] CPU1 is down
Mar 11 20:55:46 [kernel] swsusp debug: Waiting for 5 seconds.
Mar 11 20:55:46 [kernel] Enabling non-boot CPUs ...
Mar 11 20:55:46 [kernel] _cpu_up: before notifier CPU_UP_PREPARE.
Mar 11 20:55:46 [kernel] migration_call: Hi!
Mar 11 20:55:46 [kernel] rcu_cpu_notify: Hi!
Mar 11 20:55:46 [kernel] timer_cpu_notify: Hi!
Mar 11 20:55:46 [kernel] hrtimer_cpu_notify: Hi!
Mar 11 20:55:46 [kernel] cpu_callback: Hi!
Mar 11 20:55:46 [kernel] synchronize_rcu: Befor wait

---> System hangs here. After the first "Before wait" message.

                - Last output repeated twice -
Mar 11 20:55:46 [kernel] synchronize_rcu: After wait
Mar 11 20:55:46 [kernel] workqueue_cpu_callback: Hi!
Mar 11 20:55:46 [kernel] topology_cpu_callback: Hi!
Mar 11 20:55:46 [kernel] _cpu_up: after notifier CPU_UP_PREPARE.
Mar 11 20:55:46 [kernel] SMP alternatives: switching to SMP code
Mar 11 20:55:46 [kernel] Booting processor 1/1 eip 3000
Mar 11 20:55:46 [kernel] CPU 1 irqstacks, hard=c0388000 soft=c0386000
Mar 11 20:55:46 [kernel] Initializing CPU#1

