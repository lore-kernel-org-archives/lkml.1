Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZAGM6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZAGM6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZAGM5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:57:47 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:34045 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752358AbZAGM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:57:46 -0500
Date: Wed, 7 Jan 2009 23:57:34 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Willy Tarreau <w@1wt.eu>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107125734.GA26331@gondor.apana.org.au>
References: <20090107112906.GA28161@ioremap.net> <20090107115032.GA25198@gondor.apana.org.au> <20090107115605.GA29250@ioremap.net> <20090107115921.GA25323@gondor.apana.org.au> <20090107121530.GA30164@ioremap.net> <20090107122238.GB25673@gondor.apana.org.au> <20090107123741.GA31255@ioremap.net> <20090107124246.GA26034@gondor.apana.org.au> <20090107124629.GA31732@ioremap.net> <20090107125535.GC6307@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107125535.GC6307@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 01:55:35PM +0100, Willy Tarreau wrote:
> 
> kernel is 2.6.27.10 + a few patches (squashfs, etc..., nothing related to

2.6.27 will enable GSO by default if SG is enabled at registration
time.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
