Return-Path: <linux-kernel-owner+w=401wt.eu-S936339AbYBCH5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936339AbYBCH5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759499AbYBCH5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:57:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:46498 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759479AbYBCH5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:57:17 -0500
Subject: Re: [PATCH] Fix ext4 bitops
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bastian Blank <bastian@waldi.eu.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080201200240.GA28566@wavehammer.waldi.eu.org>
References: <20080201200240.GA28566@wavehammer.waldi.eu.org>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 18:36:38 +1100
Message-Id: <1202024198.7208.9.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 21:02 +0100, Bastian Blank wrote:
> Fix ext4 bitops.

Please provide a better description, as it's not obvious at first sight.

> Signed-off-by: Bastian Blank <waldi@debian.org>
> 
> diff --git a/include/asm-powerpc/bitops.h b/include/asm-powerpc/bitops.h
> index 220d9a7..d0980df 100644
> --- a/include/asm-powerpc/bitops.h
> +++ b/include/asm-powerpc/bitops.h
> @@ -363,6 +363,8 @@ unsigned long generic_find_next_le_bit(const unsigned long *addr,
>  				    unsigned long size, unsigned long offset);
>  /* Bitmap functions for the ext2 filesystem */
>  
> +#include <asm-generic/bitops/le.h>

A comment would be useful to indicate that this defines the _le versions
of the bitops as it would be easy to mistake that for something else.

>  #define ext2_set_bit(nr,addr) \
>  	__test_and_set_le_bit((nr), (unsigned long*)addr)
>  #define ext2_clear_bit(nr, addr) \
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

