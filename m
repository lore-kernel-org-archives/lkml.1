Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZKKJ0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZKKJ0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZKKJ0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:26:49 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58335 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZKKJ0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:26:48 -0500
Message-ID: <4AFA835B.9000904@garzik.org>
Date: Wed, 11 Nov 2009 04:26:51 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Glenn Maynard <glenn@zewt.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Crash during SATA reads
References: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>
In-Reply-To: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080101090808090101020005"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080101090808090101020005
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/2009 04:18 AM, Glenn Maynard wrote:
> Pid: 1311, comm: gzip Not tainted (2.6.31.6 #1) G31M-ES2L
> EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
> EIP is at 0x0
> EAX: c1ae78c0 EBX: c107cca9 ECX: c1ae78c0 EDX: 00000000
> ESI: c1ae78c0 EDI: dfa3b2c0 EBP: df29bed0 ESP: df29be94
>   DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process gzip (pid: 1311, ti=df29a000 task=df916800 task.ti=df29a000)
> Stack:
>   c107ccb1 c107e549 00000200 c11587bc 00000000 00000001 df430a94 00000000
> <0>  00000000 00005000 0000b000 00000000 dfa3b2c0 00000000 dfa3b2c0 dfa0f168
> <0>  c1158936 dfa20980 00000000 c11589ed 00000000 dfa20980 00000000 dfa3b2c0
> Call Trace:
>   [<c107ccb1>] ? end_bio_bh_io_sync+0x28/0x30
>   [<c107e549>] ? bio_endio+0x24/0x26
>   [<c11587bc>] ? blk_update_request+0xdf/0x24e
>   [<c1158936>] ? blk_update_bidi_request+0xb/0x41
>   [<c11589ed>] ? blk_end_bidi_request+0x10/0x4f
>   [<c1158a5c>] ? blk_end_request+0x7/0xc
>   [<c11abcb2>] ? scsi_end_request+0x17/0x69
>   [<c11abfc3>] ? scsi_io_completion+0x173/0x335
>   [<c11a8330>] ? scsi_finish_command+0x70/0x86
>   [<c11ac6a6>] ? scsi_softirq_done+0xd7/0xdc
>   [<c115b3f1>] ? blk_done_softirq+0x51/0x5d
>   [<c101bde0>] ? __do_softirq+0x5f/0xc8
>   [<c101be6b>] ? do_softirq+0x22/0x26
>   [<c101becd>] ? irq_exit+0x29/0x34
>   [<c1004097>] ? do_IRQ+0x53/0x63
>   [<c1002ea9>] ? common_interrupt+0x29/0x30
> Code:  Bad EIP value.
> EIP: [<00000000>] 0x0 SS:ESP 0068:df29be94
> CR2: 0000000000000000
> ---[ end trace 79f49d6371afc159 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> Pid: 1311, comm: gzip Tainted: G      D    2.6.31.6 #1
> Call Trace:
>   [<c101824c>] ? panic+0x41/0xde
>   [<c1004dcf>] ? oops_end+0x5c/0x66
>   [<c107cca9>] ? end_bio_bh_io_sync+0x20/0x30
>   [<c100eca7>] ? bad_area_nosemaphore+0xa/0xc
>   [<c126564e>] ? error_code+0x5e/0x64
>   [<c107cca9>] ? end_bio_bh_io_sync+0x20/0x30
>   [<c107007b>] ? file_update_time+0x8c/0xd8
>   [<c100ee87>] ? do_page_fault+0x0/0x1f9
>   [<c107ccb1>] ? end_bio_bh_io_sync+0x28/0x30
>   [<c107e549>] ? bio_endio+0x24/0x26
>   [<c11587bc>] ? blk_update_request+0xdf/0x24e
>   [<c1158936>] ? blk_update_bidi_request+0xb/0x41
>   [<c11589ed>] ? blk_end_bidi_request+0x10/0x4f

Looks like it is dying somewhere in the block layer, maybe the 
bh->b_end_io() pointer is NULL.

Does the attached patch trigger the added BUG_ON() statement?

	Jeff




--------------080101090808090101020005
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch"

ZGlmZiAtLWdpdCBhL2ZzL2J1ZmZlci5jIGIvZnMvYnVmZmVyLmMKaW5kZXggNmZhNTMwMi4u
MjY3ZTRkMSAxMDA2NDQKLS0tIGEvZnMvYnVmZmVyLmMKKysrIGIvZnMvYnVmZmVyLmMKQEAg
LTI5MzksNiArMjkzOSw3IEBAIHN0YXRpYyB2b2lkIGVuZF9iaW9fYmhfaW9fc3luYyhzdHJ1
Y3QgYmlvICpiaW8sIGludCBlcnIpCiAJaWYgKHVubGlrZWx5ICh0ZXN0X2JpdChCSU9fUVVJ
RVQsJmJpby0+YmlfZmxhZ3MpKSkKIAkJc2V0X2JpdChCSF9RdWlldCwgJmJoLT5iX3N0YXRl
KTsKIAorCUJVR19PTihiaC0+Yl9lbmRfaW8gPT0gTlVMTCk7CiAJYmgtPmJfZW5kX2lvKGJo
LCB0ZXN0X2JpdChCSU9fVVBUT0RBVEUsICZiaW8tPmJpX2ZsYWdzKSk7CiAJYmlvX3B1dChi
aW8pOwogfQo=
--------------080101090808090101020005--
