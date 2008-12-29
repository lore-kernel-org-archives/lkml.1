Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbYL2Vuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbYL2Vuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYL2Vuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:50:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:40236 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147AbYL2Vun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:50:43 -0500
Subject: 2.6.18 BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug()
From: Kasper Sandberg <lkml@metanurb.dk>
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 22:50:38 +0100
Message-Id: <1230587438.23771.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I just noticed, on a debian etch(stable) system, using kernel 2.6.18
some messages.

I have not experienced any real problems from it, and well.. i just
wanted to post in case someone can get some stuff out of it..

it has happened a few times.

Every night an usb disk is mounted for backup purposes, and you can with
that, estimate how often it happens.

Dont know if this happens on newer kernels.

Also, should i be worried about this? or just not care?

anyway, without further delay, the log:
BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug()
 [<c0132ab4>] unlock_cpu_hotplug+0x2c/0x54
 [<f894a25a>] do_dbs_timer+0x125/0x168 [cpufreq_ondemand]
 [<c012ac08>] run_workqueue+0x78/0xb5
 [<f894a135>] do_dbs_timer+0x0/0x168 [cpufreq_ondemand]
 [<c012b4f2>] worker_thread+0xd9/0x10b
 [<c0117778>] default_wake_function+0x0/0xc
 [<c012b419>] worker_thread+0x0/0x10b
 [<c012d86b>] kthread+0xc2/0xef
 [<c012d7a9>] kthread+0x0/0xef
 [<c0101005>] kernel_thread_helper+0x5/0xb
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug()
 [<c0132ab4>] unlock_cpu_hotplug+0x2c/0x54
 [<f894a25a>] do_dbs_timer+0x125/0x168 [cpufreq_ondemand]
 [<c012ac08>] run_workqueue+0x78/0xb5
 [<f894a135>] do_dbs_timer+0x0/0x168 [cpufreq_ondemand]
 [<c012b4f2>] worker_thread+0xd9/0x10b
 [<c0117778>] default_wake_function+0x0/0xc
 [<c012b419>] worker_thread+0x0/0x10b
 [<c012d86b>] kthread+0xc2/0xef
 [<c012d7a9>] kthread+0x0/0xef
 [<c0101005>] kernel_thread_helper+0x5/0xb
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
BUG: warning at kernel/cpu.c:51/unlock_cpu_hotplug()
 [<c0132ab4>] unlock_cpu_hotplug+0x2c/0x54
 [<f894a25a>] do_dbs_timer+0x125/0x168 [cpufreq_ondemand]
 [<c012ac08>] run_workqueue+0x78/0xb5
 [<f894a135>] do_dbs_timer+0x0/0x168 [cpufreq_ondemand]
 [<c012b4f2>] worker_thread+0xd9/0x10b
 [<c0117778>] default_wake_function+0x0/0xc
 [<c012b419>] worker_thread+0x0/0x10b
 [<c012d86b>] kthread+0xc2/0xef
 [<c012d7a9>] kthread+0x0/0xef
 [<c0101005>] kernel_thread_helper+0x5/0xb
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.


Regards,
Kasper Sandberg

