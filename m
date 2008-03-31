Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbYCaOUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbYCaOUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYCaOTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:19:52 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:55823 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbYCaOTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:19:51 -0400
Date: Mon, 31 Mar 2008 22:19:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Ralph Wuerthner <rwuerthn@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/2] hw_random: allow rng_dev_read() to return hardware errors.
Message-ID: <20080331141943.GA14688@gondor.apana.org.au>
References: <20080314092523.147382820@de.ibm.com> <20080314093046.656233449@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314093046.656233449@de.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 09:25:24AM +0000, Martin Schwidefsky wrote:
> From: Ralph Wuerthner <rwuerthn@de.ibm.com>
> 
> The api for hardware random number generators is currently limited to
> devices that never fail. If the hardware is registered as a source for
> random numbers it has to work. This prevents the use of i/o based
> random number devices where the i/o might fail.
> 
> Add a check for errors after the read from a hardware random number device.
> 
> This patch is required to support large random numbers retrieved
> from the CEX2C cards on System z.
> 
> Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Thanks for the patch.  I'll pick this up in cryptodev-2.6.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
