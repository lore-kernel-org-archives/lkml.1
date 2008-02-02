Return-Path: <linux-kernel-owner+w=401wt.eu-S1764782AbYBBIP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764782AbYBBIP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 03:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbYBBIPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 03:15:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60107 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756866AbYBBIPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 03:15:16 -0500
Message-ID: <47A42662.6090702@cn.fujitsu.com>
Date: Sat, 02 Feb 2008 16:14:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] x86: add function prototype to vm86.h
References: <1201938485.1844.6.camel@brick>
In-Reply-To: <1201938485.1844.6.camel@brick>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison Ð´µÀ:
> Global functions should include their prototypes.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/asm-x86/vm86.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-x86/vm86.h b/include/asm-x86/vm86.h
> index a5edf51..b72b9a6 100644
> --- a/include/asm-x86/vm86.h
> +++ b/include/asm-x86/vm86.h
> @@ -195,6 +195,7 @@ struct kernel_vm86_struct {
>  
>  void handle_vm86_fault(struct kernel_vm86_regs *, long);
>  int handle_vm86_trap(struct kernel_vm86_regs *, long, int);
> +struct pt_regs * save_v86_state(struct kernel_vm86_regs *);
>  

This fixes a sparse warning, but contribute to a coding style error.
checkpatch.pl complains about this patch.

so the above line should be:
	struct pt_regs *save_v86_state(struct kernel_vm86_regs *);

>  struct task_struct;
>  void release_vm86_irqs(struct task_struct *);

