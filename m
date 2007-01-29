Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXA2SQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXA2SQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 13:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXA2SQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 13:16:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:15564 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXA2SQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 13:16:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=G8yPo8KzrBsIaMD++w/aOaZhVmUIXTSR6dqzrwImxVj5+6Z68rlrZmDSsUhuWP0LMIXBO5yNiXNguuOyxzuxAePmHWFnZ1A2cLYcxUFkZSxOcmjRE5AS3ZIzuKpri1d3VEcg7BMNm8pxp5/ZV32vUD4I+MBhGOQ1zOsBFBzrKbs=
Date: Mon, 29 Jan 2007 21:15:48 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, Parag Warudkar <parag.warudkar@gmail.com>,
       dsd@gentoo.org, joerg@hydrops.han.de, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 7891] New: vdso page is no longer mapped for
Message-ID: <20070129181548.GD5546@martell.zuzino.mipt.ru>
References: <82e4877d0701271201n3aa5bdf6v7c5fb8e41ee98c80@mail.gmail.com> <20070127140233.203ef7d3.akpm@osdl.org> <200701290410.29427.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701290410.29427.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 04:10:29AM +0100, Andi Kleen wrote:
> Don't require the vDSO for handling a.out signals

> --- linux.orig/include/linux/binfmts.h
> +++ linux/include/linux/binfmts.h
> @@ -59,6 +59,7 @@ struct linux_binfmt {
>  	int (*load_shlib)(struct file *);
>  	int (*core_dump)(long signr, struct pt_regs * regs, struct file * file);
>  	unsigned long min_coredump;	/* minimal dump size */
> +	int hasvdso;

nit: has_vdso, please.

