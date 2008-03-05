Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbYCELGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbYCELGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYCELGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:06:31 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:33522 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921AbYCELGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:06:30 -0500
Date: Wed, 5 Mar 2008 19:06:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] crypto/digest.c should #include "internal.h"
Message-ID: <20080305110624.GA27552@gondor.apana.org.au>
References: <20080227212103.GQ29269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227212103.GQ29269@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:21:03PM +0200, Adrian Bunk wrote:
> Every file should include the headers containing the externs for its 
> global code (in this case for struct crypto_{init,exit}_digest_ops()).
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied to crypto-2.6.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
