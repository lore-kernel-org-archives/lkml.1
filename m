Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZA1EVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZA1EVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbZA1EVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:21:12 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:34709 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751455AbZA1EVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:21:11 -0500
Date: Wed, 28 Jan 2009 15:21:07 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: force reset of cprng on allocation
Message-ID: <20090128042107.GC13157@gondor.apana.org.au>
References: <20090123165027.GB29548@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123165027.GB29548@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 11:50:27AM -0500, Neil Horman wrote:
> pseudo RNGs provide predictable outputs based on input parateters {key, V, DT},
> the idea behind them is that only the user should know what the inputs are.
> While its nice to have default known values for testing purposes, it seems
> dangerous to allow the use of those default values without some sort of safety
> measure in place, lest an attacker easily guess the output of the cprng.  This
> patch forces the NEED_RESET flag on when allocating a cprng context, so that any
> user is forced to reseed it before use.  The defaults can still be used for
> testing, but this will prevent their inadvertent use, and be more secure.
>    
> Signed-off-by: Neil Horman <nhorman@redhat.com>

Applied to cryptodev.  Thanks Neil!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
