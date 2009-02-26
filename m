Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZBZGms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZBZGms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 01:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbZBZGmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 01:42:35 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:60049 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895AbZBZGme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 01:42:34 -0500
Date: Thu, 26 Feb 2009 14:42:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: chohnstaedt@innominate.com, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: Re:[PATCH] ixp4xx_crypto panic with fragmented packets in
	scatterlist
Message-ID: <20090226064227.GA11766@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A5654C.1080002@hiramoto.org>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Hiramoto <karl@hiramoto.org> wrote:
> 
> The attached patch fixes my issue, but am not sure if it is correct or
> will  cause problems else where.

This is what we'll do once generic chaining is available on all
architectures.  Until then it's up to the driver to fix the SG
list up before passing it to DMA.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
