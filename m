Return-Path: <linux-kernel-owner+w=401wt.eu-S1759217AbZGGQcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217AbZGGQcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757589AbZGGQc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:32:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZGGQcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:32:25 -0400
Date: Tue, 7 Jul 2009 12:32:23 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: MAX_STACK_TRACE_ENTRIES too low (2.6.31-rc2)
Message-ID: <20090707163223.GA24481@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see this every time I boot.

	Dave

BUG: MAX_STACK_TRACE_ENTRIES too low!
turning off the locking correctness validator.
Pid: 0, comm: swapper Not tainted 2.6.31-0.42.rc2.fc12.i686.PAE #1
Call Trace:
 [<c08277f3>] ? printk+0x22/0x37
 [<c04759b3>] save_trace+0x89/0xa3
 [<c0476410>] mark_lock+0xaf/0x1f6
 [<c0476c36>] ? check_usage_forwards+0x0/0x61
 [<c047755e>] __lock_acquire+0x301/0xb08
 [<c060bcc3>] ? get_hash_bucket+0x3a/0x55
 [<c0477e1c>] lock_acquire+0xb7/0xeb
 [<c060bcc3>] ? get_hash_bucket+0x3a/0x55
 [<c060bcc3>] ? get_hash_bucket+0x3a/0x55
 [<c082a537>] _spin_lock_irqsave+0x45/0x89
 [<c060bcc3>] ? get_hash_bucket+0x3a/0x55
 [<c060bcc3>] get_hash_bucket+0x3a/0x55
 [<c060d07d>] add_dma_entry+0x1f/0x4f
 [<c060d2fd>] debug_dma_map_sg+0xd0/0x136
 [<c06de03d>] ata_qc_issue+0x223/0x2c1
 [<c06e4be9>] __ata_scsi_queuecmd+0x16a/0x1c8
 [<c06c25a6>] ? scsi_done+0x0/0x32
 [<c06e4653>] ? ata_scsi_rw_xlat+0x0/0x20a
 [<c06e4d00>] ata_scsi_queuecmd+0x55/0x95
 [<c06c25a6>] ? scsi_done+0x0/0x32
 [<c06c284f>] scsi_dispatch_cmd+0x187/0x208
 [<c06c8641>] scsi_request_fn+0x33a/0x47d
 [<c05e8cb6>] __blk_run_queue+0x49/0x85
 [<c05e8db9>] blk_run_queue+0x2e/0x51
 [<c06c7b30>] scsi_run_queue+0x28d/0x32b
 [<c06c89b1>] scsi_next_command+0x3b/0x59
 [<c06c9415>] scsi_io_completion+0x1de/0x3c1
 [<c04768be>] ? trace_hardirqs_on+0x19/0x2c
 [<c06c912e>] ? scsi_device_unbusy+0x97/0xaf
 [<c06c258d>] scsi_finish_command+0xde/0xf7
 [<c06c9722>] scsi_softirq_done+0xf9/0x112
 [<c05eed28>] blk_done_softirq+0x74/0x93
 [<c0452508>] __do_softirq+0xc8/0x192
 [<c045261b>] do_softirq+0x49/0x7f
 [<c045276f>] irq_exit+0x48/0x8c
 [<c040c751>] do_IRQ+0x92/0xb7
 [<c040b035>] common_interrupt+0x35/0x3c
 [<c06704a9>] ? acpi_idle_enter_simple+0x11d/0x161
 [<c06701d2>] acpi_idle_enter_bm+0xd2/0x28c
 [<c076229a>] ? menu_select+0x48/0xc2
 [<c07613c3>] cpuidle_idle_call+0x73/0xbc
 [<c0409983>] cpu_idle+0xac/0xcd
 [<c0813ec2>] rest_init+0x66/0x79
 [<c0a86af8>] start_kernel+0x370/0x388
 [<c0a86090>] i386_start_kernel+0x7f/0x98

