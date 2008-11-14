Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYKNN4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYKNN4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYKNN4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:56:25 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:5469 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYKNN4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=uh2qUR97v7EorKP+Ob2+oDMuxcVvQATnbZlhv9B0q8uWrtzIh9Jsyg1Gr5UnRtAQGH
         58vYwvnMh63wyISPHk7rk+1LjcL/kBR6mqOYqYhsXYl0lktC9LpIZIJsSvJWEgAasNTi
         se57UEPkDOjyt9WVXQvTfmL7zXJMFFKx4L2CU=
Message-ID: <a4423d670811140556o45f0063dn85f695f74d158b03@mail.gmail.com>
Date: Fri, 14 Nov 2008 16:56:22 +0300
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       jens.axboe@oracle.com
Subject: next-20081114: WARNING: at block/blk-barrier.c:246 blk_do_ordered()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: at block/blk-barrier.c:246 blk_do_ordered+0x22b/0x26a()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.28-rc4-next-20081114 #3
Call Trace:
 <IRQ>  [<ffffffff80236d63>] warn_on_slowpath+0x58/0x7d
 [<ffffffff802570e3>] ? mark_lock+0x1c/0x37a
 [<ffffffff803a69f9>] ? elv_rb_del+0x30/0x4b
 [<ffffffff803b1092>] ? cfq_remove_request+0x180/0x1d8
 [<ffffffff803afd03>] ? __cfq_slice_expired+0xd6/0xeb
 [<ffffffff803afd31>] ? cfq_slice_expired+0x19/0x1b
 [<ffffffff803b1832>] ? cfq_dispatch_requests+0x2c1/0x37e
 [<ffffffff803aa98c>] blk_do_ordered+0x22b/0x26a
 [<ffffffff803a6560>] elv_next_request+0x1d0/0x210
 [<ffffffff80439c7c>] scsi_request_fn+0x9e/0x539
 [<ffffffff80255c66>] ? put_lock_stats+0xe/0x27
 [<ffffffff803a827e>] blk_invoke_request_fn+0x3b/0x6e
 [<ffffffff803a87fd>] __blk_run_queue+0x25/0x29
 [<ffffffff803a8822>] blk_run_queue+0x21/0x35
 [<ffffffff80439509>] scsi_run_queue+0x2cf/0x379
 [<ffffffff8043a33e>] scsi_next_command+0x36/0x46
 [<ffffffff8043a509>] scsi_end_request+0x92/0xa4
 [<ffffffff8043aae7>] scsi_io_completion+0x1a7/0x3ad
 [<ffffffff80434551>] scsi_finish_command+0xe9/0xf2
 [<ffffffff8043afd5>] scsi_softirq_done+0x10e/0x117
 [<ffffffff803ac393>] blk_done_softirq+0x7f/0x8f
 [<ffffffff8023c173>] __do_softirq+0x70/0x101
 [<ffffffff8020cc0c>] call_softirq+0x1c/0x28
 [<ffffffff8020e229>] do_softirq+0x39/0x8a
 [<ffffffff8023bd78>] irq_exit+0x45/0xa2
 [<ffffffff8020e53a>] do_IRQ+0x16a/0x19c
 [<ffffffff8020bceb>] ret_from_intr+0x0/0xf
 <EOI>  [<ffffffff80212e09>] ? mwait_idle+0x3e/0x48
 [<ffffffff80212e00>] ? mwait_idle+0x35/0x48
 [<ffffffff8020a940>] ? cpu_idle+0x51/0xba
 [<ffffffff80514f9c>] ? rest_init+0x70/0x72
---[ end trace 115cb4be7e150bb9 ]---
