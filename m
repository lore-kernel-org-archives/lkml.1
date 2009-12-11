Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZLKX5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZLKX5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZLKX5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:57:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60209 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZLKX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:57:11 -0500
Message-ID: <4B22DBEB.6090407@zytor.com>
Date: Fri, 11 Dec 2009 15:55:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 5/7] x86/pci: use u64 instead of size_t in amd_bus.c
References: <4B22D4DA.2000104@kernel.org> <4B22D746.9040807@kernel.org>
In-Reply-To: <4B22D746.9040807@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2009 03:35 PM, Yinghai Lu wrote:
> 
> 
> prepare to enable it for 32bit
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/pci/amd_bus.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/amd_bus.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/amd_bus.c
> +++ linux-2.6/arch/x86/pci/amd_bus.c
> @@ -82,8 +82,8 @@ static int __init early_fill_mp_bus_info
>  	struct pci_root_info *info;
>  	u32 reg;
>  	struct resource *res;
> -	size_t start;
> -	size_t end;
> +	u64 start;
> +	u64 end;
>  	struct range range[RANGE_NUM];
>  	u64 val;
>  	u32 address;
> 

Shouldn't this be resource_size_t?

	-hpa

