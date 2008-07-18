Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYGRLbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYGRLbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYGRLbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:31:09 -0400
Received: from 8bytes.org ([88.198.83.132]:55751 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYGRLbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:31:08 -0400
Date: Fri, 18 Jul 2008 13:31:05 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
Message-ID: <20080718113105.GA13662@8bytes.org>
References: <20080709162913H.tomof@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709162913H.tomof@acm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 04:29:41PM +0900, FUJITA Tomonori wrote:
> Should be CONFIG_GART_IOMMU instead of CONFIG_IOMMU here?
> 
> Hmm, looks like it would be nice to have more cleanups of iommu.h and
> gart.h.
> 
> This is against tip/master.
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] replace CONFIG_IOMMU with CONFIG_GART_IOMMU in iommu.h
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  include/asm-x86/iommu.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-x86/iommu.h b/include/asm-x86/iommu.h
> index 07862fd..cb7e989 100644
> --- a/include/asm-x86/iommu.h
> +++ b/include/asm-x86/iommu.h
> @@ -5,7 +5,7 @@ extern void pci_iommu_shutdown(void);
>  extern void no_iommu_init(void);
>  extern int force_iommu, no_iommu;
>  extern int iommu_detected;
> -#ifdef CONFIG_IOMMU
> +#ifdef CONFIG_GART_IOMMU
>  extern void gart_iommu_init(void);
>  extern void gart_iommu_shutdown(void);
>  extern void __init gart_parse_options(char *);

The asm-x86/iommu.h file is a leftover from some patches I submitted
last year.  I renamed iommu.h to gart.h but somehow iommu.h still exists
in mainline. I think we should check again if somebody is using that
file and remove it if not.

Joerg
