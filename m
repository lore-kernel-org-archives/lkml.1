Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbYBVWpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbYBVWpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757806AbYBVWpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:45:08 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3855 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758565AbYBVWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:45:06 -0500
Subject: Re: [PATCH 20/20] x86: Coding Style fixes to
	arch/x86/xen/multicalls.c
From: Joe Perches <joe@perches.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080222231159.34dd5b5a@paolo-desktop>
References: <20080222231159.34dd5b5a@paolo-desktop>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 14:43:37 -0800
Message-Id: <1203720217.19319.99.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 23:11 +0100, Paolo Ciarrocchi wrote:
> File is now error free.
> Compile tested.
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
>  arch/x86/xen/multicalls.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/multicalls.c b/arch/x86/xen/multicalls.c
> index 5e6f36f..5791eb2 100644
> --- a/arch/x86/xen/multicalls.c
> +++ b/arch/x86/xen/multicalls.c
> @@ -76,7 +76,7 @@ void xen_mc_flush(void)
>  		if (ret) {
>  			printk(KERN_ERR "%d multicall(s) failed: cpu %d\n",
>  			       ret, smp_processor_id());
> -			for(i = 0; i < b->mcidx; i++) {
> +			for (i = 0; i < b->mcidx; i++) {
>  				printk("  call %2d/%d: op=%lu arg=[%lx] result=%ld\n",

The printk needs a KERN_ERR prefix


