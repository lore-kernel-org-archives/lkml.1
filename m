Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbYHNToy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbYHNToy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYHNToq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:44:46 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61996 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbYHNTop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:44:45 -0400
Date: Thu, 14 Aug 2008 20:44:06 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] x86: apic - unify init_bsp_APIC
In-Reply-To: <20080814184652.475361864@gmail.com>
Message-ID: <Pine.LNX.4.55.0808142043150.7213@cliff.in.clinika.pl>
References: <20080814183428.550709025@gmail.com> <20080814184652.475361864@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:

> @@ -962,7 +962,8 @@ void __init init_bsp_APIC(void)
>  	 */
>  	apic_write(APIC_LVT0, APIC_DM_EXTINT);
>  	value = APIC_DM_NMI;
> -	if (!lapic_is_integrated())		/* 82489DX */
> +	/* discrete on 82489DX */
> +	if (!lapic_is_integrated())
>  		value |= APIC_LVT_LEVEL_TRIGGER;
>  	apic_write(APIC_LVT1, value);
>  }

 Please elaborate.

  Maciej
