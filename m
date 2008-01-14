Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYANKxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYANKxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYANKxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:53:23 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1449 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751958AbYANKxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:53:22 -0500
Date: Mon, 14 Jan 2008 21:53:07 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Subject: Re: Netperf TCP_RR(loopback) 10% regression in 2.6.24-rc6,	comparing with 2.6.22
Message-ID: <20080114105307.GA22866@gondor.apana.org.au>
References: <1199871330.3298.132.camel@ymzhang> <1200043854.3265.24.camel@ymzhang> <Pine.LNX.4.64.0801141036400.31652@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0801141036400.31652@kivilampi-30.cs.helsinki.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 08:44:40AM +0000, Ilpo Järvinen wrote:
>
> > > I tried to use bisect to locate the bad patch between 2.6.22 and 2.6.23-rc1,
> > > but the bisected kernel wasn't stable and went crazy.
> 
> TCP work between that is very much non-existing.

Make sure you haven't switched between SLAB/SLUB while testing this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
