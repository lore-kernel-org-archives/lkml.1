Return-Path: <linux-kernel-owner+w=401wt.eu-S1762438AbXK2MZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762438AbXK2MZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 07:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbXK2MZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 07:25:50 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3013 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756686AbXK2MZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:25:49 -0500
Date: Thu, 29 Nov 2007 23:25:45 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zoltan Sogor <weth@inf.u-szeged.hu>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org, Ferenc Havasi <havasi@inf.u-szeged.hu>,
       ext-adrian.hunter@nokia.com
Subject: Re: Add LZO compression support to cryptoapi
Message-ID: <20071129122545.GB30420@gondor.apana.org.au>
References: <474BE6E7.3080107@inf.u-szeged.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474BE6E7.3080107@inf.u-szeged.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zoltan:

On Tue, Nov 27, 2007 at 10:44:07AM +0100, Zoltan Sogor wrote:
> 
> I'm Zoltan Sogor at University of Szeged, Hungary, and we are working on 
> new flash file system (UBIFS) cooperating with Nokia Corp. We would like 
> to use cryptoapi in UBIFS compression/encrypt mechanism.
> 
> I've ported LZO compressor into cryptoapi. If you think the patch is 
> good, please apply it.
> 
> If you have any problem with the patch, your feedbacks are welcome.

Thanks for your patch! There's just one thing missing, tcrypt vectors.
Please resubmit with them (you can model it after deflate) and I'll add
this to cryptodev-2.6.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
