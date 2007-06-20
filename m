Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXFTUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXFTUbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXFTUbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:31:03 -0400
Received: from waste.org ([66.93.16.53]:54955 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXFTUbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:31:01 -0400
Date: Wed, 20 Jun 2007 15:30:22 -0500
From: Matt Mackall <mpm@selenic.com>
To: Alexander Gabert <pappy@gentoo.org>
Cc: Arjan van de Ven <arjan@infradead.org>, libc-alpha@sourceware.org,
       linux-kernel@vger.kernel.org, hardened@gentoo.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] get_random_long() and AT_ENTROPY for auxv, kernel 2.6.21.5
Message-ID: <20070620203022.GO11166@waste.org>
References: <4675C678.3080807@gentoo.org> <1182128803.22999.9.camel@laptopd505.fenrus.org> <4675DFA8.6060703@gentoo.org> <1182130680.22999.13.camel@laptopd505.fenrus.org> <4676601A.7070209@gentoo.org> <467948F5.3010709@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467948F5.3010709@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 05:34:13PM +0200, Alexander Gabert wrote:
> Hi,
> 
> http://dev.gentoo.org/~pappy/kernel/linux-2.6.21.5-get_urandom_long-AT_ENTROPY.patch
> 
> this patch adds the function drivers/char/random.c:get_random_long()
> and adds an AT_ENTROPY field in the auxv without config option
> (the config option was removed as suggested by Arjan on LKML).

One ought to cc: the /dev/random maintainer.

> /*
> + * get_random_long() returns a randomized unsigned long word.
> + * It recycles it's entropy cache for a given time period and
> + * uses half_md4_transform to generate a unique return value.
> + * Every REKEY_INTERVAL the cache is reloaded with fresh
> + * randomization data using get_random_bytes().
> + * This function is not intended for strong cryptographic routines.
> + */

What's the point of this?

-- 
Mathematics is the supreme nostalgia of our time.
