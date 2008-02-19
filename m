Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYBSD77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYBSD77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 22:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbYBSD7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 22:59:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:10714 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYBSD7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 22:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FvyGJ/Js5tI5cNyOIBt/ykPVumDxA3iSlmW5yAjANH/TIPfcBkIVpRdetPeOpZqCYWVnCXUX1mAXs5KgLrWneEBwPuAI8ZFT19Q6zWdDI1n07GI4kyoWqKDSjqA6jh1mBcmsGXZIdIROC0/tdSWiEy8nQceSMh/Dq2IurLrDSEM=
Message-ID: <86802c440802181959t762bc242n79d2f0d93b224f31@mail.gmail.com>
Date: Mon, 18 Feb 2008 19:59:48 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH 4/5] x86_64: check msr to get mmconfig for amd family 10h opteron v3
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200802150131.16816.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802150127.21247.yinghai.lu@sun.com>
	 <200802150128.41638.yinghai.lu@sun.com>
	 <200802150130.14915.yinghai.lu@sun.com>
	 <200802150131.16816.yinghai.lu@sun.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 15, 2008 1:31 AM, Yinghai Lu <Yinghai.Lu@sun.com> wrote:
> From: Yinghai Lu <Yinghai.Lu@Sun.COM>
>
> so even booting kernel with acpi=off or even MCFG is not there, we still can
> use MMCONFIG.
>
> Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Greg KH <greg@kroah.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/x86/pci/mmconfig-shared.c |   67 ++++++++++++++++++++++++++++---
>  1 file changed, 61 insertions(+), 6 deletions(-)
>
> Index: linux-2.6/arch/x86/pci/mmconfig-shared.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/mmconfig-shared.c
> +++ linux-2.6/arch/x86/pci/mmconfig-shared.c

Ingo/Thomas,

It seems you missed this one in the 5.

this one should be safe. it only reads msr.

Andi had concern with other one that was touching msr. I will keep
that one in my local tree.

YH
