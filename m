Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYGNXby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYGNXby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 19:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755443AbYGNXbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 19:31:46 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:51181 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113AbYGNXbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 19:31:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=g29dpEh3GYwS2apN5xoVUB5FnVmf51Fnj5q419YLig9agNNNfDZ8q2nFp2awZEK3081R5iLf2sPfQuI8q135yH3gyujpfncqSNmX3+9QW1KfVqv35UvliC2ThAK/9zfF;
Message-ID: <487BE1DB.3010206@simon.arlott.org.uk>
Date: Tue, 15 Jul 2008 00:31:39 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: WARNING: at include/linux/blkdev.h:447 blk_plug_device+0x5e/0x97()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   13.800641] usb-storage: device scan complete
[   13.804836] scsi 6:0:0:0: Direct-Access     Generic  Flash HS-CF      5.39 PQ: 0 ANSI: 0
[   13.808197] scsi 6:0:0:1: Direct-Access     Generic  Flash HS-COMBO   5.39 PQ: 0 ANSI: 0
[   13.813427] sd 6:0:0:0: [sdd] Attached SCSI removable disk
[   13.813469] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   13.818284] sd 6:0:0:1: [sde] Attached SCSI removable disk
[   13.818321] sd 6:0:0:1: Attached scsi generic sg4 type 0
[   16.769885] WARNING: at include/linux/blkdev.h:447 blk_plug_device+0x5e/0x97()
[   16.769887] Modules linked in: fglrx(P)
[   16.769893] Pid: 3214, comm: mount Tainted: P          2.6.26 #01382-ga41eeba-dirty
[   16.769895] 
[   16.769896] Call Trace:
[   16.769903]  [<ffffffff8023329c>] warn_on_slowpath+0x58/0x86
[   16.769910]  [<ffffffff804c20e1>] ? bitmap_get_counter+0x156/0x1fa
[   16.769912]  [<ffffffff803381f7>] blk_plug_device+0x5e/0x97
[   16.769916]  [<ffffffff804c2b96>] bitmap_startwrite+0x12a/0x172
[   16.769920]  [<ffffffff802ac880>] ? bio_alloc_bioset+0x4b/0x8f
[   16.769924]  [<ffffffff804ae662>] make_request+0x5c3/0x658
[   16.769928]  [<ffffffff80248f97>] ? up_read+0x9/0xb
[   16.769930]  [<ffffffff8033776b>] generic_make_request+0x1e3/0x21a
[   16.769933]  [<ffffffff802ac80f>] ? bvec_alloc_bs+0x81/0xa7
[   16.769935]  [<ffffffff80338d36>] submit_bio+0x111/0x11a
[   16.769939]  [<ffffffff802a88d8>] submit_bh+0xf0/0x114
[   16.769943]  [<ffffffff802aa557>] __block_write_full_page+0x1b8/0x29f
[   16.769946]  [<ffffffff802ae753>] ? blkdev_get_block+0x0/0x4d
[   16.769949]  [<ffffffff802ae753>] ? blkdev_get_block+0x0/0x4d
[   16.769952]  [<ffffffff802aa730>] block_write_full_page+0xf2/0xfb
[   16.769955]  [<ffffffff802ae394>] blkdev_writepage+0x13/0x15
[   16.769958]  [<ffffffff80263e50>] __writepage+0x12/0x2b
[   16.769961]  [<ffffffff80264305>] write_cache_pages+0x1ae/0x303
[   16.769963]  [<ffffffff80263e3e>] ? __writepage+0x0/0x2b
[   16.769967]  [<ffffffff80299c5a>] ? d_splice_alias+0xec/0xf8
[   16.769970]  [<ffffffff80298955>] ? __d_lookup+0xe3/0x149
[   16.769972]  [<ffffffff80264479>] generic_writepages+0x1f/0x25
[   16.769975]  [<ffffffff802644a7>] do_writepages+0x28/0x37
[   16.769980]  [<ffffffff8025e426>] __filemap_fdatawrite_range+0x55/0x60
[   16.769983]  [<ffffffff8025e5cb>] filemap_fdatawrite+0x1a/0x1c
[   16.769986]  [<ffffffff8025e5e6>] filemap_write_and_wait+0x19/0x38
[   16.769989]  [<ffffffff802a9589>] sync_blockdev+0x1b/0x1d
[   16.769991]  [<ffffffff80289800>] __fsync_super+0x5e/0x6f
[   16.769993]  [<ffffffff80289822>] fsync_super+0x11/0x21
[   16.769996]  [<ffffffff8028987c>] do_remount_sb+0x4a/0x194
[   16.769999]  [<ffffffff8029eb0e>] do_remount+0x111/0x147
[   16.770002]  [<ffffffff8029f6fd>] do_mount+0x147/0x1de
[   16.770006]  [<ffffffff8026e178>] ? handle_mm_fault+0x1f9/0x6e5
[   16.770008]  [<ffffffff802638d0>] ? __alloc_pages_nodemask+0x9/0xb
[   16.770011]  [<ffffffff8027d3f8>] ? alloc_pages_current+0x96/0x9f
[   16.770014]  [<ffffffff8029f81d>] sys_mount+0x89/0xd5
[   16.770018]  [<ffffffff8023eedb>] ? sys_rt_sigprocmask+0x58/0xd7
[   16.770022]  [<ffffffff8020b39b>] system_call_after_swapgs+0x7b/0x80
[   16.770024] 

-- 
Simon Arlott
