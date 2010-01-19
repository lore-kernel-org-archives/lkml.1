Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794Ab0ASSBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab0ASSBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 13:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902Ab0ASSBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 13:01:06 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:33765 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab0ASSBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 13:01:05 -0500
Date: Tue, 19 Jan 2010 11:59:34 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 25/37] ram_buffer_extend_print
In-Reply-To: <1263611228-6751-26-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.00.1001191158010.22304@router.home>
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org> <1263611228-6751-26-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thats good regardless and easy to review

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>


On Fri, 15 Jan 2010, Yinghai Lu wrote:

> ---
>  arch/x86/kernel/e820.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
> index c5c52da..62235e7 100644
> --- a/arch/x86/kernel/e820.c
> +++ b/arch/x86/kernel/e820.c
> @@ -1127,6 +1127,9 @@ void __init e820_reserve_resources_late(void)
>  			end = MAX_RESOURCE_SIZE;
>  		if (start >= end)
>  			continue;
> +		printk(KERN_DEBUG "reserve RAM buffer: %016Lx - %016Lx ",
> +			       (unsigned long long) start,
> +			       (unsigned long long) end);
>  		reserve_region_with_split(&iomem_resource, start, end,
>  					  "RAM buffer");
>  	}
>
