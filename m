Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbYKCWd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbYKCWd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbYKCWdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:33:35 -0500
Received: from outbound-mail-133.bluehost.com ([67.222.39.23]:34156 "HELO
	outbound-mail-133.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752993AbYKCWde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:33:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=X1AbNTK2fBRKxbl6nwLrPhvzVws+Rx287uUlpYJ7H3H8QFGUYOrF0TwmABGPxrgDxc77ZXND9aBUEAOtgr+2CrySw1lAoRinVF4ZHfGm04i5611VCGsJf590zNj2a5Rk;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] pci: annotate return value of pci_ioremap_bar with __iomem
Date: Mon, 3 Nov 2008 14:33:31 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <1225661563.5496.65.camel@brick>
In-Reply-To: <1225661563.5496.65.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031433.31746.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, November 2, 2008 1:32 pm Harvey Harrison wrote:
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/linux/pci.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 9194adf..03b0b8c 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1142,7 +1142,7 @@ static inline void pci_mmcfg_late_init(void) { }
>  #endif
>
>  #ifdef CONFIG_HAS_IOMEM
> -static inline void * pci_ioremap_bar(struct pci_dev *pdev, int bar)
> +static inline void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
>  {
>  	/*
>  	 * Make sure the BAR is actually a memory resource, not an IO resource

Applied to my for-linus branch.

Thanks,
Jesse

