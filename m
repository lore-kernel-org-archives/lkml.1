Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbYHIKDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbYHIKDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 06:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYHIKC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 06:02:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51683 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYHIKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 06:02:55 -0400
Date: Sat, 9 Aug 2008 11:01:44 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] fix watchdog/at91rm9200_wdt.c compilation
Message-ID: <20080809100144.GA18510@flint.arm.linux.org.uk>
References: <20080808155744.GD14495@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808155744.GD14495@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 06:57:45PM +0300, Adrian Bunk wrote:
> This patch fixes the following compile error:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/watchdog/at91rm9200_wdt.o
> at91rm9200_wdt.c:188: error: 'at91_wdt_ioctl' undeclared here (not in a 
> make[3]: *** [drivers/watchdog/at91rm9200_wdt.o] Error 1

Can we please get these fixes to Linus ASAP - this kind and quantity
of breakage should have never made it to Linus' kernel.  (s3c2410_wdt,
at91rm9200_wdt, and wdt285 all broken with trivial compile errors).

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
