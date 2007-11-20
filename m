Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbXKTGwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbXKTGwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbXKTGwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:52:24 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3525 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758099AbXKTGwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:52:23 -0500
Date: Tue, 20 Nov 2007 14:52:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       goodmenkernel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Is there any word about this bug in gcc ?
Message-ID: <20071120065212.GA14702@gondor.apana.org.au>
References: <E1IuMnZ-0003o3-00@gondolin.me.apana.org.au> <4742831F.9040408@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4742831F.9040408@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 10:47:59PM -0800, H. Peter Anvin wrote:
> 
> This one is definitely messy.  There is absolutely no way to know what 
> gcc has miscompiled.  It looks to me that both gcc 4.2 and 4.3 are 
> affected, any others?

I just tested it here and gcc 3.3 is also affected so presumably
everything in between is too.  Gcc 2.95 is not affected.  I don't
have the intervening versions to test.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
