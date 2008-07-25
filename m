Return-Path: <linux-kernel-owner+w=401wt.eu-S1753019AbYGYOUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbYGYOUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYGYOT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:19:59 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:35269 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751303AbYGYOT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:19:59 -0400
Date: Fri, 25 Jul 2008 22:19:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.26: [<c0133cc1>] __alloc_pages_internal+0x331/0x343
Message-ID: <20080725141953.GA19418@gondor.apana.org.au>
References: <BAY103-DAV74E605DFBE7CC22EEA732B2870@phx.gbl> <E1KMO85-00052z-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KMO85-00052z-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 10:18:45PM +0800, Herbert Xu wrote:
> 
> Pick one of these:
> 
> 1) You have less RAM;
> 2) Your memory fragmentation has deteriorated;
> 3) Most likely: you were just lucky :)

Actually even more likely, someone has sent you a huge packet
which triggered this (> 32K if I remember your trace correctly).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
