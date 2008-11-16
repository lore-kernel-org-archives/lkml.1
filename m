Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYKPDrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYKPDrx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 22:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbYKPDro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 22:47:44 -0500
Received: from casper.infradead.org ([85.118.1.10]:35797 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbYKPDrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 22:47:43 -0500
Date: Sat, 15 Nov 2008 19:48:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tytso@mit.edu, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: kerneloops.org database passes the 100.000 mark
Message-ID: <20081115194801.7a257704@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today, just a few days short of the first anniversity of the project, 
the kerneloops.org database of oopses and warnings has passed 
the 100.000 stored oopses/warnings.

Number one hundred thousand is....

WARNING: at drivers/net/wireless/iwlwifi/iwl-tx.c:1196 iwl_tx_cmd_complete+0x57/0x22d [iwlcore]()

stored at http://www.kerneloops.org/raw.php?rawid=100000

(and yes there is some irony in this)

Looking back at the first 100.000 entries, the top 10 files and top 10 oopses 
of these 100.000 are shown below:

Per file statistics
6986	external/madwifi/wrapper
5838	fs/jbd/journal.c
5633	drivers/parport/procfs.c
3581	external/fireglx/binary
3473	external/madwifi/binary
3078	sound/core/init.c
2640	net/sched/sch_generic.c
1872	drivers/ata/libata-sff.c
1615	kernel/time/tick-broadcast.c
1536	drivers/ssb/main.c
					Count	Last version	First version 
1. journal_update_superblock		6045 	2.6.27.5	2.6.24-rc6-git1 
	A patch for this is -mm for a while already
2. parport_device_proc_register		588	2.6.27-rc7-git1	2.6.24-rc5 
	Alan has a partial fix for this one pending
3. ath_dynamic_sysctl_register(P)	5408	2.6.25.9	2.6.24 
4. init_ath_hal (P)			3300	2.6.26.3	2.6.24 
5. snd_card_register			3076	2.6.25.14	2.6.24 
6. firegl_ioctl (P)			2891	2.6.26.6	2.6.25 
7. dev_watchdog()			2631	2.6.27.4	2.6.26-rc3 
8. tick_broadcast_oneshot_control	1609	2.6.25.14	2.6.24-rc4 
9. ath_sysctl_register	(P)		1551	2.6.26.3	2.6.24-rc4-git4
10. ssb_tmslow_reject_bitmask		1536 	2.6.26.6	2.6.24


Other than the top 2 items, which have patches, we've done a pretty good job of fixing
the high occurance bugs (excluding the binary drivers which we obviously cannot fix)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
