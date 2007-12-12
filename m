Return-Path: <linux-kernel-owner+w=401wt.eu-S1758167AbXLLJ4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167AbXLLJ4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 04:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbXLLJ4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 04:56:23 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:2420 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbXLLJ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 04:56:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qot/a+3BVITsp6U3YaDtz6EBW3RYM04frH0SyOMVcPMw8KHB/GoGIRGhD556ISs8uWun/ulQaXsjse/If/fujN99aewxFlvRcbc6DgfjI7tyH8nWdA7wZEqnm7FJAh/Qj6SV1DT0WKl1zxxJQvi23c7fGO1YTw9sj8vKqwdoKtU=
Message-ID: <a8e1da0712120156v2b855f64jf40f9971ebf9b689@mail.gmail.com>
Date: Wed, 12 Dec 2007 17:56:21 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Oliver Falk" <oliver@linux-kernel.at>
Subject: Re: kernel panic - help!?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <475FA716.2000105@linux-kernel.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475FA716.2000105@linux-kernel.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 5:17 PM, Oliver Falk <oliver@linux-kernel.at> wrote:
> Can someone explain me that?
>
> Dec 12 00:24:15 santorini kernel: Unable to handle kernel NULL pointer
> dereference at virtual address 00000000
> Dec 12 00:24:15 santorini kernel:  printing eip:
> Dec 12 00:24:15 santorini kernel: c0190182
> Dec 12 00:24:15 santorini kernel: *pde = 1b62b001
> Dec 12 00:24:15 santorini kernel: Oops: 0000 [#1]
> Dec 12 00:24:15 santorini kernel: SMP
> Dec 12 00:24:15 santorini kernel: Modules linked in: mptctl mptbase sg
> md5 ipv6 i2c_dev i2c_core button battery ac uhci_hcd ehci_hcd hw_rand
> om tg3 bonding(U) floppy ata_piix libata dm_snapshot dm_zero dm_mirror
> ext3 jbd dm_mod cciss sd_mod scsi_mod
> Dec 12 00:24:15 santorini kernel: CPU:    2
> Dec 12 00:24:15 santorini kernel: EIP:    0060:[<c0190182>]    Not
> tainted VLI
> Dec 12 00:24:15 santorini kernel: EFLAGS: 00010246   (2.6.9-55.0.9.ELsmp)
> Dec 12 00:24:15 santorini kernel: EIP is at sysfs_readdir+0x123/0x187
> Dec 12 00:24:15 santorini kernel: eax: 00000000   ebx: e1f04880   ecx:
> ffffffff   edx: 00000000
> Dec 12 00:24:15 santorini kernel: esi: e1f04884   edi: 00000000   ebp:
> f6bf2144   esp: ec134f60
> Dec 12 00:24:15 santorini kernel: ds: 007b   es: 007b   ss: 0068
> Dec 12 00:24:15 santorini kernel: Process save (pid: 13931,
> threadinfo=ec134000 task=f59c12b0)
> Dec 12 00:24:15 santorini kernel: Stack: 00000000 f7e14e40 c016baf5
> ec134fa0 f2eb8180 c0332640 f2eb8180 f7c45438
> Dec 12 00:24:15 santorini kernel:        c016baf5 c016b771 ec134fa0
> ffffffda 08304764 f2eb8180 00000000 c016bdab
> Dec 12 00:24:15 santorini kernel:        083047cc 083047b4 00000f98
> ffffffea 00000009 08304764 b7fccff4 ec134000
> Dec 12 00:24:15 santorini kernel: Call Trace:
> Dec 12 00:24:15 santorini kernel:  [<c016baf5>] filldir64+0x0/0x11a
> Dec 12 00:24:15 santorini kernel:  [<c016baf5>] filldir64+0x0/0x11a
> Dec 12 00:24:15 santorini kernel:  [<c016b771>] vfs_readdir+0x7d/0xa5
> Dec 12 00:24:15 santorini kernel:  [<c016bdab>] sys_getdents64+0x80/0xba
> Dec 12 00:24:15 santorini kernel:  [<c02d64db>] syscall_call+0x7/0xb
> Dec 12 00:24:15 santorini kernel:  [<c02d007b>]
> unix_dgram_sendmsg+0x23c/0x45d
> Dec 12 00:24:16 santorini kernel: Code: 04 89 69 0c 8b 75 00 8b 44 24 04
> 83 c0 0c 39 c6 74 73 8d 5e fc 83 7b 14 00 74 66 89 d8 e8 07 ec ff f
> f 89 c2 83 c9 ff 31 c0 89 d7 <f2> ae f7 d1 49 0f b7 43 1c c1 e8 0c 50 ff
> 73 20 8b 44 24 18 ff
> Dec 12 00:24:16 santorini kernel:  <0>Fatal exception: panic in 5 seconds
> --

Please tell the kernel version before post.
