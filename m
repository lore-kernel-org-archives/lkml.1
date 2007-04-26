Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbXDZDeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbXDZDeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbXDZDeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:34:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:43750 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbXDZDer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hidz4pNsJ99WNP0HpijODLSdWiOBwjkF3udHn3MvDer6X5AKQZDKgHeuqJyT1sNcDKq/dORRmYpQ4jjHdlWw7TRJpXEsa6XW7GXBbaApFCAUOJKoyRF3SG1jcNxarhOdlL21RMV0n/WjW2hfh4WJiQfkJVCnxwQQS5jILbtt2to=
Message-ID: <a8f16e2b0704252034t74a86f2em90f5f95176c3fde8@mail.gmail.com>
Date: Thu, 26 Apr 2007 07:34:45 +0400
From: "Dan Kruchinin" <dubalom@gmail.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1: Oops and Gnome desktop freezes
In-Reply-To: <1177512596.4856.17.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177512596.4856.17.camel@daplas>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 4/25/07, Antonino A. Daplas <adaplas@gmail.com> wrote:
> The Gnome desktop does not finish launching.  And I get this tracing,
> all coming from Gnome apps.
>
> Tony
>
> BUG: unable to handle kernel paging request at virtual address c0a74000
>  printing eip:
> c014c469
> *pde = 005f3027
> *pte = 00000000
> Oops: 0002 [#1]
> Modules linked in: xt_pkttype xt_tcpudp ipt_LOG xt_limit nfsd exportfs
> lockd nfs_acl sunrpc snd_pcm_oss snd_mixer_oss snd_seq button battery ac
> ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter
> ip6table_filter nf_conntrack_ipv4 nf_conntrack ip_tables ip6_tables
> x_tables nls_iso8859_1 nls_cp437 vfat fat nls_utf8 ntfs reiserfs loop
> usblp snd_via82xx snd_ac97_codec ac97_bus snd_pcm ide_cd cdrom snd_timer
> snd_page_alloc snd_mpu401_uart rtc_cmos snd_rawmidi rtc_core
> snd_seq_device rtc_lib snd soundcore via_rhine ehci_hcd uhci_hcd usbcore
> sc92031 via_agp 8139too i2c_viapro ext3 mbcache jbd edd fan thermal
> processor via82cxxx ide_disk ide_core
> CPU:    0
> EIP:    0060:[<c014c469>]    Tainted: G      D VLI
> EFLAGS: 00210246   (2.6.21-rc7-mm1-default #74)
> EIP is at get_page_from_freelist+0x2b5/0x359
> eax: 00000000   ebx: c1014e80   ecx: 00000400   edx: c0002fe8
> esi: c1014e80   edi: c0a74000   ebp: d27c9eb0   esp: d27c9e58
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process evolution-data- (pid: 4745, ti=d27c8000 task=d32a8aa0
> task.ti=d27c8000)
> Stack: c0363628 00000002 00000000 c0113c58 0805c000 c1fccd40 c0a74000
> 00000001
>        00000000 001280d2 c03640f0 c0363600 00200246 00000002 00000000
> 00000001
>        00000001 00000000 00200246 c03640f4 001280d2 00000000 d27c9f00
> c014c5f5
> Call Trace:
>  [<c0104378>] show_trace_log_lvl+0x1a/0x30
>  [<c0104429>] show_stack_log_lvl+0x9b/0xaa
>  [<c01045ee>] show_registers+0x1b6/0x288
>  [<c01047a7>] die+0xe7/0x1fc
>  [<c0111a1d>] do_page_fault+0x429/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  [<c014c5f5>] __alloc_pages+0xe8/0x29e
>  [<c01541dd>] __handle_mm_fault+0x16d/0x5fc
>  [<c01117f2>] do_page_fault+0x1fe/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  =======================
> INFO: lockdep is turned off.
> Code: 00 00 66 83 7d cc 00 c7 45 ec 00 00 00 00 78 30 eb 36 ba 03 00 00
> 00 89 d8 e8 8d 63 fc ff b9 00 04 00 00 89 45 c0 31 c0 8b 7d c0 <f3> ab
> 8b 45 c0 ba 03 00 00 00 83 c3 20 e8 d8 63 fc ff ff 45 ec
> EIP: [<c014c469>] get_page_from_freelist+0x2b5/0x359 SS:ESP
> 0068:d27c9e58
> note: evolution-data-[4745] exited with preempt_count 1
> BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> in_atomic():1, irqs_disabled():0
> INFO: lockdep is turned off.
>  [<c0104378>] show_trace_log_lvl+0x1a/0x30
>  [<c0104ec9>] show_trace+0x12/0x14
>  [<c0104f22>] dump_stack+0x16/0x18
>  [<c011328e>] __might_sleep+0xc9/0xcf
>  [<c0129dac>] down_read+0x18/0x50
>  [<c0133210>] futex_wake+0x35/0xcd
>  [<c0133339>] do_futex+0x91/0x104d
>  [<c01343b6>] sys_futex+0xc1/0xd4
>  [<c01149e5>] mm_release+0x84/0x8b
>  [<c0117d32>] exit_mm+0x19/0xc3
>  [<c011926c>] do_exit+0x1f8/0x744
>  [<c0104896>] die+0x1d6/0x1fc
>  [<c0111a1d>] do_page_fault+0x429/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  [<c014c5f5>] __alloc_pages+0xe8/0x29e
>  [<c01541dd>] __handle_mm_fault+0x16d/0x5fc
>  [<c01117f2>] do_page_fault+0x1fe/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  =======================
> BUG: scheduling while atomic: evolution-data-/0x10000001/4745
> INFO: lockdep is turned off.
>  [<c0104378>] show_trace_log_lvl+0x1a/0x30
>  [<c0104ec9>] show_trace+0x12/0x14
>  [<c0104f22>] dump_stack+0x16/0x18
>  [<c02a76a1>] __sched_text_start+0x71/0x553
>  [<c0113cb3>] __cond_resched+0x28/0x3f
>  [<c02a7bf1>] cond_resched+0x29/0x34
>  [<c0129db1>] down_read+0x1d/0x50
>  [<c0133210>] futex_wake+0x35/0xcd
>  [<c0133339>] do_futex+0x91/0x104d
>  [<c01343b6>] sys_futex+0xc1/0xd4
>  [<c01149e5>] mm_release+0x84/0x8b
>  [<c0117d32>] exit_mm+0x19/0xc3
>  [<c011926c>] do_exit+0x1f8/0x744
>  [<c0104896>] die+0x1d6/0x1fc
>  [<c0111a1d>] do_page_fault+0x429/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  [<c014c5f5>] __alloc_pages+0xe8/0x29e
>  [<c01541dd>] __handle_mm_fault+0x16d/0x5fc
>  [<c01117f2>] do_page_fault+0x1fe/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  =======================
> BUG: unable to handle kernel paging request at virtual address c0a75000
>  printing eip:
> c0152d68
> *pde = 005f3027
> *pte = 00000000
> Oops: 0002 [#2]
> Modules linked in: xt_pkttype xt_tcpudp ipt_LOG xt_limit nfsd exportfs
> lockd nfs_acl sunrpc snd_pcm_oss snd_mixer_oss snd_seq button battery ac
> ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter
> ip6table_filter nf_conntrack_ipv4 nf_conntrack ip_tables ip6_tables
> x_tables nls_iso8859_1 nls_cp437 vfat fat nls_utf8 ntfs reiserfs loop
> usblp snd_via82xx snd_ac97_codec ac97_bus snd_pcm ide_cd cdrom snd_timer
> snd_page_alloc snd_mpu401_uart rtc_cmos snd_rawmidi rtc_core
> snd_seq_device rtc_lib snd soundcore via_rhine ehci_hcd uhci_hcd usbcore
> sc92031 via_agp 8139too i2c_viapro ext3 mbcache jbd edd fan thermal
> processor via82cxxx ide_disk ide_core
> CPU:    0
> EIP:    0060:[<c0152d68>]    Tainted: G      D VLI
> EFLAGS: 00010296   (2.6.21-rc7-mm1-default #74)
> EIP is at __do_fault+0x17a/0x301
> eax: c0a75000   ebx: c1014ea0   ecx: 00000400   edx: c0002fe4
> esi: d2207000   edi: c0a75000   ebp: d7ad9f00   esp: d7ad9ea8
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process smart (pid: 4687, ti=d7ad8000 task=d6c99510 task.ti=d7ad8000)
> Stack: d28766e8 d2876730 d7ad9ec0 00000007 c0a75000 d2207000 b7a3d650
> d291b668
>        c1fcc0c0 01000001 c12440e0 c1fcc128 d6c99510 18100073 d7ad9f40
> b7a3d000
>        00000003 00000001 00000002 d291b668 b7a3d650 c1fb38f4 d7ad9f50
> c015419f
> Call Trace:
>  [<c0104378>] show_trace_log_lvl+0x1a/0x30
>  [<c0104429>] show_stack_log_lvl+0x9b/0xaa
>  [<c01045ee>] show_registers+0x1b6/0x288
>  [<c01047a7>] die+0xe7/0x1fc
>  [<c0111a1d>] do_page_fault+0x429/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  [<c015419f>] __handle_mm_fault+0x12f/0x5fc
>  [<c01117f2>] do_page_fault+0x1fe/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  =======================
> INFO: lockdep is turned off.
> Code: 00 00 8b 45 d0 ba 03 00 00 00 e8 9d fa fb ff ba 04 00 00 00 89 45
> bc 89 d8 e8 8e fa fb ff b9 00 04 00 00 8b 75 bc 89 45 b8 89 c7 <f3> a5
> 8b 45 bc ba 03 00 00 00 e8 dc fa fb ff 8b 45 b8 ba 04 00
> EIP: [<c0152d68>] __do_fault+0x17a/0x301 SS:ESP 0068:d7ad9ea8
> note: smart[4687] exited with preempt_count 2
> BUG: scheduling while atomic: smart/0x10000002/4687
> INFO: lockdep is turned off.
>  [<c0104378>] show_trace_log_lvl+0x1a/0x30
>  [<c0104ec9>] show_trace+0x12/0x14
>  [<c0104f22>] dump_stack+0x16/0x18
>  [<c02a76a1>] __sched_text_start+0x71/0x553
>  [<c0113cb3>] __cond_resched+0x28/0x3f
>  [<c02a7bf1>] cond_resched+0x29/0x34
>  [<c0129db1>] down_read+0x1d/0x50
>  [<c0117d44>] exit_mm+0x2b/0xc3
>  [<c011926c>] do_exit+0x1f8/0x744
>  [<c0104896>] die+0x1d6/0x1fc
>  [<c0111a1d>] do_page_fault+0x429/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  [<c015419f>] __handle_mm_fault+0x12f/0x5fc
>  [<c01117f2>] do_page_fault+0x1fe/0x4f8
>  [<c02aa111>] error_code+0x71/0x78
>  =======================
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I have just the same tracing, but my gnome desktop works pretty good
until I launch some application which "eats" much mem, like evince or
firefox. After it my X server automatically restarts .

Dan Kruchinin.
