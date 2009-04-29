Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZD2Fcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZD2Fcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZD2Fcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:32:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38895 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbZD2Fcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:32:43 -0400
Date: Wed, 29 Apr 2009 07:32:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Edward Goggin <egoggin@vmware.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: Simple typo in reboot.c when enabling CONFIG_KDB_KDUMP
Message-ID: <20090429053233.GB4103@elte.hu>
References: <B1FD1A0C73AC4E46A4F95BADC77079D35F55F114@PA-EXMBX02.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B1FD1A0C73AC4E46A4F95BADC77079D35F55F114@PA-EXMBX02.vmware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Edward Goggin <egoggin@vmware.com> wrote:

> Patch 1 of 1
> 
> Simple typo when enabling CONFIG_KDB_KDUMP.
> 
> Signed-off-by: Ed Goggin <egoggin@vmware.com>
> 
> 
> --- linux-2.6.29/arch/x86/kernel/reboot.c	2009-04-28 14:37:30.000000000 -0400
> +++ linux-2.6.29.fix/arch/x86/kernel/./reboot.c	2009-04-28 14:37:37.000000000 -0400
> @@ -649,7 +649,7 @@ void halt_current_cpu(struct pt_regs *re
>  #ifdef CONFIG_X86_32
>  	if (!user_mode_vm(regs)) {
>  		crash_fixup_ss_esp(&fixed_regs, regs);
> -		regs = &fixed_Regs;
> +		regs = &fixed_regs;
>  	}
>  #endif
>          crash_save_cpu(regs, raw_smp_processor_id());

There's no such code in the current upstream kernel. Exactly which 
kernel version (sha1) are you sending a patch against?

	Ingo
