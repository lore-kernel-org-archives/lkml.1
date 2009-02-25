Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZBYO2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZBYO2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbZBYO1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:27:51 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:42360 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753722AbZBYO1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:27:50 -0500
Date: Wed, 25 Feb 2009 22:27:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
       Frank Seidel <frank@f-seidel.de>, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, nhorman@tuxdriver.com,
       lho@amcc.com, kaber@trash.net, darrenrjenkins@gmail.com
Subject: Re: [PATCH][trivial] crypto: tcrypt - reduce stack size
Message-ID: <20090225142744.GA4331@gondor.apana.org.au>
References: <49A54C23.8090209@suse.de> <20090225142000.GA4136@gondor.apana.org.au> <49A55499.6090700@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A55499.6090700@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 03:24:25PM +0100, Frank Seidel wrote:
> Herbert Xu wrote:
> >> -	char output[1024];
> > 
> > How about just making it static?
> 
> Well, it was static before. But there
> are efforts to reduce current stack memory
> footprints.

Well if it's static it won't be using any stack memory.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
