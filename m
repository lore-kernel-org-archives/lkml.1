Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbZEEIiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbZEEIiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 04:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbZEEIiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 04:38:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55826 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782AbZEEIiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 04:38:06 -0400
Date: Tue, 5 May 2009 09:36:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, hartleys@visionengravers.com,
       mcrapet@gmail.com, fred99@carolina.rr.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] Double check memmap is actually valid with a memmap
	has unexpected holes
Message-ID: <20090505083614.GA28688@n2100.arm.linux.org.uk>
References: <20090505082944.GA25904@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505082944.GA25904@csn.ul.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 09:29:44AM +0100, Mel Gorman wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index e02b893..6d79051 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -925,10 +925,9 @@ config OABI_COMPAT
>  	  UNPREDICTABLE (in fact it can be predicted that it won't work
>  	  at all). If in doubt say Y.
>  
> -config ARCH_FLATMEM_HAS_HOLES
> +config ARCH_HAS_HOLES_MEMORYMODEL

Can we arrange for EP93xx to select this so we don't have it enabled for
everyone.

The other user of this was RPC when it was flatmem only, but since it has
been converted to sparsemem it's no longer an issue there.
