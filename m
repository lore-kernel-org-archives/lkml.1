Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbYHNTmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbYHNTmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:42:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYHNTlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:41:53 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61965 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753299AbYHNTlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:41:52 -0400
Date: Thu, 14 Aug 2008 20:41:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 7/8] x86: apic - unify sync_Arb_IDs
In-Reply-To: <20080814184652.317090901@gmail.com>
Message-ID: <Pine.LNX.4.55.0808142038320.7213@cliff.in.clinika.pl>
References: <20080814183428.550709025@gmail.com> <20080814184652.317090901@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:

 Hmm, are you living in the past?

> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
> index 1d5f830..ec0f18f 100644
> --- a/arch/x86/kernel/apic_32.c
> +++ b/arch/x86/kernel/apic_32.c
> @@ -919,8 +919,7 @@ void __init sync_Arb_IDs(void)
>  	apic_wait_icr_idle();
>  
>  	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
> -	apic_write(APIC_ICR,
> -		   APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
> +	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
>  }
>  
>  /*
[etc...]

 Well, I think this one is backwards...  There are exceptions, but the
general rule is to with within the width of the terminal.

  Maciej
