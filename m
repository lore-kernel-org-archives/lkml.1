Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZHCRZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZHCRZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZHCRZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:25:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44370 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZHCRZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:25:20 -0400
Date: Mon, 3 Aug 2009 18:24:59 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Drop superfluous casts in nr_free_pages() callers
Message-ID: <20090803172459.GC32479@flint.arm.linux.org.uk>
Mail-Followup-To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arch@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0908031808440.11620@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 06:11:42PM +0200, Geert Uytterhoeven wrote:
> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> index 8277802..bc927ee 100644
> --- a/arch/arm/mm/init.c
> +++ b/arch/arm/mm/init.c
> @@ -536,8 +536,8 @@ void __init mem_init(void)
>  
>  	printk(KERN_NOTICE "Memory: %luKB available (%dK code, "
>  		"%dK data, %dK init, %luK highmem)\n",
> -		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
> -		codesize >> 10, datasize >> 10, initsize >> 10,
> +		nr_free_pages() << (PAGE_SHIFT-10), codesize >> 10,
> +		datasize >> 10, initsize >> 10,
>  		(unsigned long) (totalhigh_pages << (PAGE_SHIFT-10)));
>  
>  	if (PAGE_SIZE >= 16384 && num_physpages <= 128) {

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
