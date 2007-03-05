Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbXCEC6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbXCEC6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbXCEC6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:58:18 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46222 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbXCEC6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:58:17 -0500
Message-ID: <45EB8748.8070902@vmware.com>
Date: Sun, 04 Mar 2007 18:58:16 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make arch/i386/kernel/vmi.c:vmi_pmd_clear() static
References: <20070305014742.GR3441@stusta.de>
In-Reply-To: <20070305014742.GR3441@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the needlessly global vmi_pmd_clear() static.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
>
> ---
> --- linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c.old	2007-03-04 20:32:08.000000000 +0100
> +++ linux-2.6.21-rc2-mm1/arch/i386/kernel/vmi.c	2007-03-04 20:33:51.000000000 +0100
> @@ -517,7 +517,7 @@
>  	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
>  }
>  
> -void vmi_pmd_clear(pmd_t *pmd)
> +static void vmi_pmd_clear(pmd_t *pmd)
>  {
>  	const pte_t pte = { 0 };
>  	vmi_check_page_type(__pa(pmd) >> PAGE_SHIFT, VMI_PAGE_PMD);
>
>
>   
Acked-by: Zachary Amsden <zach@vmware.com>
