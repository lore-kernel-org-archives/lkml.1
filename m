Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXDUVQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXDUVQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXDUVPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:15:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33543 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752964AbXDUVPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:15:42 -0400
Date: Sat, 21 Apr 2007 22:19:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC PATCH 1/3] x86: use defined names for all CPU feature
 flags
Message-ID: <20070421221900.2a6505f4@the-village.bc.nu>
In-Reply-To: <46294444.1050608@redhat.com>
References: <4629438C.4070209@redhat.com>
	<46294444.1050608@redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> --- 2.6.21-rc7-d390.orig/arch/x86_64/kernel/setup.c
> +++ 2.6.21-rc7-d390/arch/x86_64/kernel/setup.c
> @@ -576,7 +576,7 @@ static void __cpuinit init_amd(struct cp
>  
>  	/* Bit 31 in normal CPUID used for nonstandard 3DNow ID;
>  	   3DNow is IDd by bit 31 in extended CPUID (1*32+31) anyway */
> -	clear_bit(0*32+31, &c->x86_capability);
> +	clear_bit(X86_FEATURE_PBE, &c->x86_capability);

And this is more clear why ?

> +#define X86_FEATURE_PBE		(0*32+31) /* PBE */

For these platforms it isn't "PBE" its 3DNow

Alan
