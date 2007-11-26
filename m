Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbXKZPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbXKZPYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbXKZPYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:24:24 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3802 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750914AbXKZPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:24:23 -0500
Date: Mon, 26 Nov 2007 23:24:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: "'Patrick McHardy'" <kaber@trash.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] xfrm_hash: kmalloc + memset conversion to kzalloc
Message-ID: <20071126152415.GE28022@gondor.apana.org.au>
References: <007c01c8300b$176975a0$9c94fea9@jason> <474A8D97.2030808@trash.net> <000301c83016$774dcba0$9c94fea9@jason>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301c83016$774dcba0$9c94fea9@jason>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 10:23:51AM +0000, Joonwoo Park wrote:
> 2007/11/26, Patrick McHardy <kaber@trash.net>:
> > How about also switching vmalloc/get_free_pages to GFP_ZERO
> > and getting rid of the memset entirely while you're at it?
> > 
> 
> xfrm_hash: kmalloc + memset conversion to kzalloc
> fix to avoid memset entirely.

Patch applied.  Thanks everyone!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
