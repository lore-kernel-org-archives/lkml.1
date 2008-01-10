Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbYAJKp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbYAJKp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYAJKpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:45:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbYAJKpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:45:11 -0500
Message-ID: <4785F6A1.5020202@redhat.com>
Date: Thu, 10 Jan 2008 05:42:41 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH] x86: trivial whitespace in kprobes.c
References: <1199954157.19760.22.camel@brick>
In-Reply-To: <1199954157.19760.22.camel@brick>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
> Ingo, you could/should probably fold this into Masami's kprobe
> unification patch.

The original code had these whitespace, because (I think)
kretprobe_trampoline_holder() had just hold a memory space
for hooking function return. And now, it has actual code.
So the whitespace can be removed.

Thank you.

> 
> commit 17735e04f7f18bea4dcbe4daa31c34acac55b332
> Author: Masami Hiramatsu <mhiramat@redhat.com>
> Date:   Wed Jan 9 13:30:50 2008 +0100
> 
>     kprobes code for x86 unification
> 
> in current(ish) x86.git
> 
>  arch/x86/kernel/kprobes.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 53ba6a5..93aff49 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -583,8 +583,8 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>   * When a retprobed function returns, this code saves registers and
>   * calls trampoline_handler() runs, which calls the kretprobe's handler.
>   */
> - void __kprobes kretprobe_trampoline_holder(void)
> - {
> +void __kprobes kretprobe_trampoline_holder(void)
> +{
>  	asm volatile (
>  			".global kretprobe_trampoline\n"
>  			"kretprobe_trampoline: \n"
> @@ -670,7 +670,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
>  			"	popf\n"
>  #endif
>  			"	ret\n");
> - }
> +}
>  
>  /*
>   * Called from kretprobe_trampoline

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

