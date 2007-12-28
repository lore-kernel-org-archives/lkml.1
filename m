Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbXL1Hhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbXL1Hhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 02:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755735AbXL1HhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 02:37:25 -0500
Received: from pils.linux-kernel.at ([213.129.242.82]:8490 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbXL1HhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 02:37:22 -0500
Message-ID: <4774A786.10603@linux-kernel.at>
Date: Fri, 28 Dec 2007 08:36:38 +0100
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: linux-kernel@vger.kernel.org
Subject: Re: kernel panic - help!?
References: <475FA716.2000105@linux-kernel.at> <20071212125505.2c4508dc@mandriva.com.br>
In-Reply-To: <20071212125505.2c4508dc@mandriva.com.br>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-MailScanner-ID: lBS7acPZ017588
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-3.009, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60,
	PLING_QUERY 1.39)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2007 03:55 PM, Luiz Fernando N. Capitulino wrote:
> Em Wed, 12 Dec 2007 10:17:10 +0100
> Oliver Falk <oliver@linux-kernel.at> escreveu:
> 
> | Can someone explain me that?
> | 
> | Dec 12 00:24:15 santorini kernel: Unable to handle kernel NULL pointer
> | dereference at virtual address 00000000
> | Dec 12 00:24:15 santorini kernel:  printing eip:
> | Dec 12 00:24:15 santorini kernel: c0190182
> | Dec 12 00:24:15 santorini kernel: *pde = 1b62b001
> | Dec 12 00:24:15 santorini kernel: Oops: 0000 [#1]
> | Dec 12 00:24:15 santorini kernel: SMP
> | Dec 12 00:24:15 santorini kernel: Modules linked in: mptctl mptbase sg
> | md5 ipv6 i2c_dev i2c_core button battery ac uhci_hcd ehci_hcd hw_rand
> | om tg3 bonding(U) floppy ata_piix libata dm_snapshot dm_zero dm_mirror
> | ext3 jbd dm_mod cciss sd_mod scsi_mod
> | Dec 12 00:24:15 santorini kernel: CPU:    2
> | Dec 12 00:24:15 santorini kernel: EIP:    0060:[<c0190182>]    Not
> | tainted VLI
> | Dec 12 00:24:15 santorini kernel: EFLAGS: 00010246   (2.6.9-55.0.9.ELsmp)
> | Dec 12 00:24:15 santorini kernel: EIP is at sysfs_readdir+0x123/0x187
> | Dec 12 00:24:15 santorini kernel: eax: 00000000   ebx: e1f04880   ecx:
> | ffffffff   edx: 00000000
> | Dec 12 00:24:15 santorini kernel: esi: e1f04884   edi: 00000000   ebp:
> | f6bf2144   esp: ec134f60
> | Dec 12 00:24:15 santorini kernel: ds: 007b   es: 007b   ss: 0068
> | Dec 12 00:24:15 santorini kernel: Process save (pid: 13931,
> | threadinfo=ec134000 task=f59c12b0)
> | Dec 12 00:24:15 santorini kernel: Stack: 00000000 f7e14e40 c016baf5
> | ec134fa0 f2eb8180 c0332640 f2eb8180 f7c45438
> | Dec 12 00:24:15 santorini kernel:        c016baf5 c016b771 ec134fa0
> | ffffffda 08304764 f2eb8180 00000000 c016bdab
> | Dec 12 00:24:15 santorini kernel:        083047cc 083047b4 00000f98
> | ffffffea 00000009 08304764 b7fccff4 ec134000
> | Dec 12 00:24:15 santorini kernel: Call Trace:
> | Dec 12 00:24:15 santorini kernel:  [<c016baf5>] filldir64+0x0/0x11a
> | Dec 12 00:24:15 santorini kernel:  [<c016baf5>] filldir64+0x0/0x11a
> | Dec 12 00:24:15 santorini kernel:  [<c016b771>] vfs_readdir+0x7d/0xa5
> | Dec 12 00:24:15 santorini kernel:  [<c016bdab>] sys_getdents64+0x80/0xba
> | Dec 12 00:24:15 santorini kernel:  [<c02d64db>] syscall_call+0x7/0xb
> | Dec 12 00:24:15 santorini kernel:  [<c02d007b>]
> | unix_dgram_sendmsg+0x23c/0x45d
> | Dec 12 00:24:16 santorini kernel: Code: 04 89 69 0c 8b 75 00 8b 44 24 04
> | 83 c0 0c 39 c6 74 73 8d 5e fc 83 7b 14 00 74 66 89 d8 e8 07 ec ff f
> | f 89 c2 83 c9 ff 31 c0 89 d7 <f2> ae f7 d1 49 0f b7 43 1c c1 e8 0c 50 ff
> | 73 20 8b 44 24 18 ff
> | Dec 12 00:24:16 santorini kernel:  <0>Fatal exception: panic in 5 seconds
> 
>  Is this a CentOS kernel? If so, you should report the problem to them:
> 
> http://bugs.centos.org/main_page.php

No. It's RHEL.

-of
