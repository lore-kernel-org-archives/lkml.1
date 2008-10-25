Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYJYO2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYJYO2P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYJYO17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:27:59 -0400
Received: from h4.dl5rb.org.uk ([81.2.74.4]:44511 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751915AbYJYO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:27:58 -0400
Date: Sat, 25 Oct 2008 15:27:44 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MIPS] IP22: Small cleanups
Message-ID: <20081025142740.GB1827@linux-mips.org>
References: <1224888417-26494-1-git-send-email-dmitri.vorobiev@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224888417-26494-1-git-send-email-dmitri.vorobiev@movial.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 01:46:56AM +0300, Dmitri Vorobiev wrote:

> diff --git a/arch/mips/sgi-ip22/ip22-int.c b/arch/mips/sgi-ip22/ip22-int.c
> index f6d9bf4..5b9b4f3 100644
> --- a/arch/mips/sgi-ip22/ip22-int.c
> +++ b/arch/mips/sgi-ip22/ip22-int.c
> @@ -16,6 +16,7 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
> +#include <linux/time.h>
>  
>  #include <asm/mipsregs.h>
>  #include <asm/addrspace.h>
> @@ -23,7 +24,6 @@
>  #include <asm/sgi/ioc.h>
>  #include <asm/sgi/hpc3.h>
>  #include <asm/sgi/ip22.h>
> -#include <asm/time.h>

<linux/time.h> does not include <asm/time.h>.  This sort of stuff happens
if you believe checkpatch.pl.  You only got away because the header isn't
needed anyway.  I'll apply the patch with this bit dropped.

  Ralf

PS: Suspicion breeds confidence.  At least in case of checkpatch ;-)
