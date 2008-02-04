Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbYBDFXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbYBDFXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 00:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYBDFXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 00:23:11 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:46625 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbYBDFXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 00:23:11 -0500
Date: Mon, 4 Feb 2008 10:52:59 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ext4 bitops
Message-ID: <20080204052259.GB7494@skywalker>
References: <20080201200240.GA28566@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201200240.GA28566@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 09:02:40PM +0100, Bastian Blank wrote:
> Fix ext4 bitops.
> 
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
> +
>  #define ext2_set_bit(nr,addr) \
>  	__test_and_set_le_bit((nr), (unsigned long*)addr)
>  #define ext2_clear_bit(nr, addr) \


I am not sure what the changes are for. Can you send me the build logs
with the compile error. I always test Ext4 on powerpc so not sure what
went wrong.

-aneesh
