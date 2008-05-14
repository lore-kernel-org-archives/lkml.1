Return-Path: <linux-kernel-owner+w=401wt.eu-S1760669AbYENCBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760669AbYENCBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 22:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbYENCAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 22:00:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:11854 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbYENCAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 22:00:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Ma6476nmmtKvQ/BjtA/j93QcUBKuaZv+n5uftF/3U4LLpYPPev8z4FN62EfRlfIBHznfTypo55ctT14s/dI4gikxG0x0IP2MwimNQYqW8lsp3fwZP3JGfEv1LQ1HaGEWJtxUDRI72/hSYYh5y/1uOZb47348BCGvkJ/7J0hikqc=
Message-ID: <86802c440805131900r2c3cca56sb45f80f26dc65780@mail.gmail.com>
Date: Tue, 13 May 2008 19:00:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: blk_queue_init_tags warning
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0xfe/0x154()
Modules linked in:
Pid: 1509, comm: scsi_wq_0 Not tainted
2.6.26-rc1-sched-devel.git-x86-latest.git-00589-g5bb43f9-dirty #382

Call Trace:
 [<ffffffff802634d5>] warn_on_slowpath+0x6c/0xa7
 [<ffffffff802a8b42>] ? ftrace_record_ip+0x223/0x286
 [<ffffffff8050607f>] ? __blk_queue_init_tags+0x38/0x8e
 [<ffffffff80505f33>] ? init_tag_map+0x96/0xdb
 [<ffffffff80506095>] ? __blk_queue_init_tags+0x4e/0x8e
 [<ffffffff80506326>] blk_queue_init_tags+0xfe/0x154
 [<ffffffff806fa7d8>] qla2xxx_slave_configure+0x8b/0xf7
 [<ffffffff8068da34>] scsi_probe_and_add_lun+0x99f/0xb1f
 [<ffffffff8068cbc8>] ? scsi_alloc_target+0x25b/0x2d7
 [<ffffffff8068dec8>] __scsi_scan_target+0xdd/0x657
 [<ffffffff802a8b42>] ? ftrace_record_ip+0x223/0x286
 [<ffffffff8022a4f0>] ? mcount_call+0x5/0x35
 [<ffffffff8068ea76>] scsi_scan_target+0xab/0xd6
 [<ffffffff8022a4f0>] ? mcount_call+0x5/0x35
 [<ffffffff80697dc1>] fc_scsi_scan_rport+0x92/0xc8
 [<ffffffff80697d2f>] ? fc_scsi_scan_rport+0x0/0xc8
 [<ffffffff80276d45>] run_workqueue+0x97/0x13c
 [<ffffffff80277b1d>] worker_thread+0xf4/0x119
 [<ffffffff8027b8e0>] ? autoremove_wake_function+0x0/0x63
 [<ffffffff80277a29>] ? worker_thread+0x0/0x119
 [<ffffffff8027b6dd>] kthread+0x61/0xa8
 [<ffffffff8025ce01>] ? schedule_tail+0x3c/0x87
 [<ffffffff8022b528>] child_rip+0xa/0x12
 [<ffffffff8027b67c>] ? kthread+0x0/0xa8
 [<ffffffff8022b51e>] ? child_rip+0x0/0x12

---[ end trace b774192c17464dd8 ]---
