Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206Ab0A3C1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab0A3C1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 21:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683Ab0A3C1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 21:27:24 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:46039 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752639Ab0A3C1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 21:27:23 -0500
Date: Sat, 30 Jan 2010 13:27:21 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wolfgang Walter <wolfgang.walter@stwm.de>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32: padlock_sha1 and hmac broken?
Message-ID: <20100130022721.GA8324@gondor.apana.org.au>
References: <201001300044.15769.wolfgang.walter@stwm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001300044.15769.wolfgang.walter@stwm.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 12:44:15AM +0100, Wolfgang Walter wrote:
> Hello,
> 
> I upgraded some machines with VIA processors from (vanilla) 2.6.31 to 
> 2.6.32.7.
> 
> If I build the kernel 2.6.32.7 with CONFIG_CRYPTO_DEV_PADLOCK_SHA=y and 
> padlock supports sha, hmac(sha1) is missing and IPSEC with hmac(sha1) no 
> longer is possible.

Can you please attach the dmesg output so we can see if there
were any error messages?

Please also try "modprobe tcrypt mode=101".

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
