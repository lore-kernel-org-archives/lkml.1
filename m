Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbZC0HKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbZC0HKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 03:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZC0HJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 03:09:58 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:44629 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbZC0HJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 03:09:57 -0400
Date: Fri, 27 Mar 2009 15:09:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Hohnstaedt <chohnstaedt@innominate.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>, karl@hiramoto.org,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] crypto: fix handling of sg buffers in ixp4xx driver
Message-ID: <20090327070930.GA27346@gondor.apana.org.au>
References: <20090226232025.GE5811@n2100.arm.linux.org.uk> <20090227005033.GA20046@gondor.apana.org.au> <20090302114511.GE6283@elara.bln.innominate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302114511.GE6283@elara.bln.innominate.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 12:45:12PM +0100, Christian Hohnstaedt wrote:
> 
>  - keep dma functions away from chained scatterlists.
>    Use the existing scatterlist iteration inside the driver
>    to call dma_map_single() for each chunk and avoid dma_map_sg().
> 
> Signed-off-by: Christian Hohnstaedt <chohnstaedt@innominate.com>
> Tested-By:  Karl Hiramoto <karl@hiramoto.org>

Applied to crypto-2.6.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
