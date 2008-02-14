Return-Path: <linux-kernel-owner+w=401wt.eu-S1763108AbYBNCHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763108AbYBNCHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYBNCGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:06:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:13052 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYBNCGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:06:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,349,1199692800"; 
   d="scan'208";a="339628881"
Subject: Re: [2.6 patch] x86: make struct efi_phys static
From: "Huang, Ying" <ying.huang@intel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080213212936.GF3383@cs181133002.pp.htv.fi>
References: <20080213212936.GF3383@cs181133002.pp.htv.fi>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 14 Feb 2008 10:07:22 +0800
Message-Id: <1202954842.5026.45.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 14 Feb 2008 02:06:23.0936 (UTC) FILETIME=[33048C00:01C86EAE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-13 at 23:29 +0200, Adrian Bunk wrote:
> Thuis patch makes the needlessly global struct efi_phys static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 3002c1d384e748f2928823ff4b10ed4d6082dceb 
> diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
> index 1411324..1211ab2 100644
> --- a/arch/x86/kernel/efi.c
> +++ b/arch/x86/kernel/efi.c
> @@ -54,7 +54,7 @@ EXPORT_SYMBOL(efi);
>  
>  struct efi_memory_map memmap;
>  
> -struct efi efi_phys __initdata;
> +static struct efi efi_phys __initdata;
>  static efi_system_table_t efi_systab __initdata;
>  
>  static int __init setup_noefi(char *arg)

Reviewed-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying

