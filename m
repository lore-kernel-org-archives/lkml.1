Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbYAaLXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbYAaLXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 06:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYAaLXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 06:23:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34037 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbYAaLXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 06:23:09 -0500
Subject: Re: XFS oops in vanilla 2.6.24
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>
In-Reply-To: <fnqmbl$ubh$1@ultimate100.geggus.net>
References: <fnqmbl$ubh$1@ultimate100.geggus.net>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 12:23:11 +0100
Message-Id: <1201778591.28547.291.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lets CC the XFS maintainer..

On Wed, 2008-01-30 at 20:23 +0000, Sven Geggus wrote:
> Hi there,
> 
> I get the following with 2.6.24:
> 
> Ending clean XFS mount for filesystem: dm-0
> BUG: unable to handle kernel paging request at virtual address f2134000
> printing eip: c021a13a *pde = 010b5067 *pte = 32134000 
> Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> Modules linked in: radeon drm rfcomm l2cap sym53c8xx scsi_transport_spi snd_via82xx 8139too snd_mpu401_uart snd_ens1371 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc via_agp agpgart
> 
> Pid: 3889, comm: bash Not tainted (2.6.24 #3)
> EIP: 0060:[<c021a13a>] EFLAGS: 00010282 CPU: 0
> EIP is at xfs_file_readdir+0xfa/0x18c
> EAX: 00000000 EBX: 000002f5 ECX: 00000020 EDX: 00000000
> ESI: 00000000 EDI: f2133ff8 EBP: f227ff68 ESP: f227ff10
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process bash (pid: 3889, ti=f227e000 task=f7205a80 task.ti=f227e000)
> Stack: 000002f5 00000000 2c000137 00000000 00000000 c0165358 f227ff94 f221c810 
>        f2d85e48 00000000 00000000 00000000 000002f5 00000000 f2133000 00001000 
>        00000ff8 000002f9 00000000 c0421c80 f221c810 f1cdbe48 f227ff88 c0165543 
> Call Trace:
>  [<c0104da3>] show_trace_log_lvl+0x1a/0x2f
>  [<c0104e53>] show_stack_log_lvl+0x9b/0xa3
>  [<c0104efb>] show_registers+0xa0/0x1e2
>  [<c010514c>] die+0x10f/0x1dd
>  [<c0113555>] do_page_fault+0x43a/0x519
>  [<c040fe52>] error_code+0x6a/0x70
>  [<c0165543>] vfs_readdir+0x5d/0x89
>  [<c01655cd>] sys_getdents64+0x5e/0xa0
>  [<c0103f06>] syscall_call+0x7/0xb
>  =======================
> Code: 89 74 24 04 81 e3 ff ff ff 7f 89 1c 24 ff 55 bc 85 c0 0f 85 82 00 00 00 8b 4f 10 31 d2 83 c1 1f 83 e1 f8 29 4d d0 19 55 d4 01 cf <8b> 57 08 8b 4f 0c 89 55 d8 89 4d dc 83 7d d4 00 7f a1 7c 06 83 
> EIP: [<c021a13a>] xfs_file_readdir+0xfa/0x18c SS:ESP 0068:f227ff10
> ---[ end trace e518e1370efb695e ]---
> 
> Sven
> 

