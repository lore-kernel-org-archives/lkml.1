Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbYCNIYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbYCNIYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbYCNIYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:24:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:34380 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbYCNIYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:24:10 -0400
Date: Fri, 14 Mar 2008 16:24:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Roel Kluin <12o3l@tiscali.nl>, LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: be*_add_cpu conversion
Message-ID: <20080314082402.GA17717@gondor.apana.org.au>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-2-git-send-email-marcin.slusarz@gmail.com> <47B2A98B.4050408@tiscali.nl> <20080213183628.GB6150@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213183628.GB6150@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 07:36:49PM +0100, Marcin Slusarz wrote:
>
> crypto: replace all adds to big endians variables with be*_add_cpu
> 
> replace all:
> big_endian_variable = cpu_to_beX(beX_to_cpu(big_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	beX_add_cpu(&big_endian_variable, expression_in_cpu_byteorder);
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Roel Kluin <12o3l@tiscali.nl>

Patch applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
