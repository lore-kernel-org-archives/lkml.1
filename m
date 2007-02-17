Return-Path: <linux-kernel-owner+w=401wt.eu-S932698AbXBQSgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbXBQSgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932699AbXBQSgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:36:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:16712 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698AbXBQSgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:36:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=iWSMlSY9aYOX8OfbsAHUgBS6YdMcHTZE9aeDYwPkUrmPAoITuBc+P9bnV+aIN3SIW7M8zX5gC+14ZWwGRBrAXg5HVR6ObLg3P3Vsh8ZVaHquRJ4voVcHtPeR74dtAGIIoRAUaQMPiWxaqu74Uzm4lYjqA0JTTa18oMDkwVYzPLU=
Message-ID: <45D74B37.1040507@googlemail.com>
Date: Sat, 17 Feb 2007 19:36:39 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-02-17-03-25.tar.gz uploaded
References: <200702171127.l1HBRnhe025635@shell0.pdx.osdl.net>
In-Reply-To: <200702171127.l1HBRnhe025635@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-02-17-03-25.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-17-03-25.tar.gz
> 

BUG: unable to handle kernel paging request at virtual address 6b6b6b6f
 printing eip:
c01f7a8f
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
last sysfs file: /devices/platform/i2c-9191/9191-0290/temp2_input
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nfsd exportfs lockd nfs_acl autofs4 sunrpc af_packet nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink xt_tcpudp iptable_filter ip_tables x_tables ipv6 binfmt_misc thermal processor fan container nvram snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss evdev snd_mixer_oss snd_pcm snd_timer intel_agp skge snd soundcore snd_page_alloc agpgart i2c_i801 sk98lin 8139too mii ide_cd cdrom rtc unix
CPU:    1
EIP:    0060:[<c01f7a8f>]    Not tainted VLI
EFLAGS: 00010297   (2.6.20-mm2 #1)
EIP is at __make_request+0xfc/0x32e
eax: ffffffff   ebx: 6b6b6b6b   ecx: 00f01417   edx: 6b6b6b6b
esi: f7f5ba14   edi: f1e82724   ebp: f7c55cb8   esp: f7c55c88
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process pdflush (pid: 177, ti=f7c54000 task=c7509550 task.ti=f7c54000)
Stack: f7c55c94 c020f32b f7e17cbc f7c55ca0 c0336921 00000001 f7c2f6f8 f1e82724
       f7c55cec 00800000 f7f5ba14 f1e82724 f7c55d30 c01f5128 ef071ef0 0000000c
       00000000 f7c55cdc c0179c03 ef071ef0 f7e08840 00000000 c017a30f 00f01417
Call Trace:
 [<c0105312>] show_trace_log_lvl+0x1a/0x2f
 [<c01053c4>] show_stack_log_lvl+0x9d/0xac
 [<c01055c0>] show_registers+0x1ed/0x34c
 [<c010583c>] die+0x11d/0x234
 [<c011a8e1>] do_page_fault+0x47c/0x55b
 [<c0336d54>] error_code+0x7c/0x84
 [<c01f5128>] generic_make_request+0x2e1/0x30f
 [<c01f7614>] submit_bio+0x132/0x13a
 [<c019e063>] submit_bh+0xf6/0x113
 [<c019f659>] __block_write_full_page+0x242/0x35c
 [<c019fbcc>] block_write_full_page+0xc9/0xd1
 [<c01a265a>] blkdev_writepage+0xf/0x11
 [<c01637e3>] __writepage+0xb/0x25
 [<c0163c74>] write_cache_pages+0x19d/0x2b4
 [<c0163dad>] generic_writepages+0x22/0x2a
 [<c0163de0>] do_writepages+0x2b/0x48
 [<c019a598>] __writeback_single_inode+0x1fc/0x334
 [<c019aa63>] generic_sync_sb_inodes+0x1c4/0x28e
 [<c019ab4a>] sync_sb_inodes+0x1d/0x20
 [<c019ad50>] writeback_inodes+0x79/0xc0
 [<c01643f8>] wb_kupdate+0x7a/0xdb
 [<c016493e>] pdflush+0xf1/0x187
 [<c013532b>] kthread+0xb5/0xde
 [<c0104f93>] kernel_thread_helper+0x7/0x10
 =======================
Code: 83 f8 02 75 0d 89 f9 89 da 89 f0 e8 7b e7 ff ff eb 0e 48 75 13 89 f9 89 da 89 f0 e8 77 e4 ff ff 85 c0 0f 85 2b 02 00 00 8b 5b 04 <8b> 43 04 0f 18 00 90 8b 45 e8 83 c0 14 39 c3 75 bb 8b 86 18 01
EIP: [<c01f7a8f>] __make_request+0xfc/0x32e SS:ESP 0068:f7c55c88

0xc01f7a8f is in __make_request (include/asm/processor.h:725).
720        However we don't do prefetches for pre XP Athlons currently
721        That should be fixed. */
722     #define ARCH_HAS_PREFETCH
723     static inline void prefetch(const void *x)
724     {
725             alternative_input(ASM_NOP4,
726                               "prefetchnta (%1)",
727                               X86_FEATURE_XMM,
728                               "r" (x));
729     }


http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-02-17-03-25/mm-dmesg
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-02-17-03-25/mm-config

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
