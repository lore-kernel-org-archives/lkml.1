Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbXFRG1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbXFRG1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088AbXFRG1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:27:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44637 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbXFRG1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:27:09 -0400
Date: Mon, 18 Jun 2007 11:57:41 +0530
From: "S. P. Prasanna" <prasanna@in.ibm.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] include/linux/kprobes.h: always offer show_registers() prototype
Message-ID: <20070618062741.GA27180@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <20070617234304.GG3588@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617234304.GG3588@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Jun 18, 2007 at 01:43:04AM +0200, Adrian Bunk wrote:
> Allow gcc to perform show_registers() type checking also with 
> CONFIG_KPROBES=n.
> 
Adrian,

Please implement it as Andrew suggested, when this was patch was posted
eariler. Refer this discussion thread below.

http://lkml.org/lkml/2007/4/27/576

NACK

Thanks
Prasanna

> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> 
> This patch has been sent on:
> - 27 Apr 2007
> - 27 Mar 2007
> 
>  include/linux/kprobes.h |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.21-rc4-mm1/include/linux/kprobes.h.old	2007-03-26 15:28:27.000000000 +0200
> +++ linux-2.6.21-rc4-mm1/include/linux/kprobes.h	2007-03-26 15:32:23.000000000 +0200
> @@ -163,7 +163,6 @@
>  extern void arch_arm_kprobe(struct kprobe *p);
>  extern void arch_disarm_kprobe(struct kprobe *p);
>  extern int arch_init_kprobes(void);
> -extern void show_registers(struct pt_regs *regs);
>  extern kprobe_opcode_t *get_insn_slot(void);
>  extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
>  extern void kprobes_inc_nmissed_count(struct kprobe *p);
> @@ -241,4 +240,7 @@
>  {
>  }
>  #endif				/* CONFIG_KPROBES */
> +
> +void show_registers(struct pt_regs *regs);
> +
>  #endif				/* _LINUX_KPROBES_H */

-- 
Prasanna S.P.
Linux Technology Center
India Software Labs, IBM Bangalore
Email: prasanna@in.ibm.com
Ph: 91-80-41776329
