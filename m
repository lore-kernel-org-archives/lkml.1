Return-Path: <linux-kernel-owner+w=401wt.eu-S1759946AbXKTG4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946AbXKTG4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759596AbXKTGyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:54:35 -0500
Received: from koto.vergenet.net ([210.128.90.7]:44518 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759503AbXKTGye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:54:34 -0500
Date: Tue, 20 Nov 2007 15:54:33 +0900
From: Simon Horman <horms@verge.net.au>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Jes Sorensen <jes@sgi.com>,
       Tony Luck <tony.luck@intel.com>, linux-altix@sgi.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 01/59] arch/ia64: Add missing "space"
Message-ID: <20071120065431.GC10490@verge.net.au>
References: <1195523331-15303-1-git-send-email-joe@perches.com> <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

> diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
> index 5fd65d8..90518e4 100644
> --- a/arch/ia64/kernel/kprobes.c
> +++ b/arch/ia64/kernel/kprobes.c
> @@ -182,8 +182,8 @@ static int __kprobes unsupported_inst(uint template, uint  slot,
>  	qp = kprobe_inst & 0x3f;
>  	if (is_cmp_ctype_unc_inst(template, slot, major_opcode, kprobe_inst)) {
>  		if (slot == 1 && qp)  {
> -			printk(KERN_WARNING "Kprobes on cmp unc"
> -					"instruction on slot 1 at <0x%lx>"
> +			printk(KERN_WARNING "Kprobes on cmp unc "
> +					"instruction on slot 1 at <0x%lx> "
>  					"is not supported\n", addr);
>  			return -EINVAL;
>  
> @@ -221,8 +221,8 @@ static int __kprobes unsupported_inst(uint template, uint  slot,
>  			 * bit 12 to be equal to 1
>  			 */
>  			if (slot == 1 && qp) {
> -				printk(KERN_WARNING "Kprobes on test bit"
> -						"instruction on slot at <0x%lx>"
> +				printk(KERN_WARNING "Kprobes on test bit "
> +						"instruction on slot at <0x%lx> "
>  						"is not supported\n", addr);
>  				return -EINVAL;
>  			}

Is it really neccessary for this fragment to create a line that
is greater than 80 characters long? Persumably the entire reason
that the printk line was split in the first place was to avoid
a long line.

[snip]

-- 
Horms

