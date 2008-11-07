Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYKGTHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYKGTHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYKGTG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:06:59 -0500
Received: from smtp-out-45.synserver.de ([217.119.50.45]:1034 "HELO
	smtp-out-45.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750920AbYKGTG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:06:58 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 2858
Date: Fri, 7 Nov 2008 20:06:55 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [arch/x86/vdso/vdso32-syms.lds] Error 1
Message-ID: <20081107190655.GC2442@gentoox2.trippelsdorf.de>
References: <20081107181117.GA29006@gentoox2.trippelsdorf.de> <49148F94.2080303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49148F94.2080303@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 10:57:24AM -0800, H. Peter Anvin wrote:
> Also, if you could execute the following commands and include the output:
> 
> nm arch/x86/vdso/vdso32-sysenter.so.dbg
> nm arch/x86/vdso/vdso32-int80.so.dbg
> 
> My guess at this point is a bug in nm.
> 
markus@gentoox2 linux % nm arch/x86/vdso/vdso32-sysenter.so.dbg
00000000 A LINUX_2.5
00000000 a VDSO32_PRELINK
00000430 t VDSO32_SYSENTER_RETURN
00000410 t VDSO32_rt_sigreturn
00000400 t VDSO32_sigreturn
00000420 t VDSO32_vsyscall
00000040 a VDSO32_vsyscall_eh_frame_size
00000308 a _DYNAMIC
00000380 a _GLOBAL_OFFSET_TABLE_
00000410 T __kernel_rt_sigreturn
00000400 T __kernel_sigreturn
00000420 T __kernel_vsyscall
markus@gentoox2 linux % nm arch/x86/vdso/vdso32-int80.so.dbg
00000000 A LINUX_2.5
00000000 a VDSO32_PRELINK
00000410 t VDSO32_rt_sigreturn
00000400 t VDSO32_sigreturn
00000420 t VDSO32_vsyscall
00000040 a VDSO32_vsyscall_eh_frame_size
000002f4 a _DYNAMIC
00000380 a _GLOBAL_OFFSET_TABLE_
00000410 T __kernel_rt_sigreturn
00000400 T __kernel_sigreturn
00000420 T __kernel_vsyscall

-- 
Markus
