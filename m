Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZLCTlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZLCTlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756052AbZLCTlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:41:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37149 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbZLCTlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:41:39 -0500
Date: Thu, 3 Dec 2009 19:41:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4]ARM: NUC900: enable uart support for nuc932
Message-ID: <20091203194132.GA27666@n2100.arm.linux.org.uk>
References: <4B167281.1090708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B167281.1090708@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:58:25PM +0800, Wan ZongShun wrote:
> diff --git a/arch/arm/mach-w90x900/clock.h b/arch/arm/mach-w90x900/clock.h
> index b9ea2e6..2a2a54a 100644
> --- a/arch/arm/mach-w90x900/clock.h
> +++ b/arch/arm/mach-w90x900/clock.h
> @@ -14,8 +14,10 @@
>  
>  #ifndef CONFIG_CPU_NUC932
>  #define EXTCLK	15000000
> +#define UARTCLK	11313600
>  #else
>  #define EXTCLK	27000000
> +#define UARTCLK	57139200
>  #endif

As far as I can see, these are the only thing which prevent a single
kernel being built to cover both NUC900 and NUC932.

Can we make their selection something which is done at runtime instead
of compile time?  This comments goes for patch 5837/1 in the patch
system as well.
