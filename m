Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYHDRNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYHDRNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYHDRNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:13:36 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36692 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753646AbYHDRNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:13:35 -0400
Date: Tue, 5 Aug 2008 01:13:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, dwmw2@infradead.org,
       austin_zhang@linux.intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate	CRC32c algorithm by new crypto API.
Message-ID: <20080804171316.GA13819@gondor.apana.org.au>
References: <1217866496.29139.75.camel@think.oraclecorp.com> <E1KQ3Be-0003T3-00@gondolin.me.apana.org.au> <20080804100605.4f0921f4@infradead.org> <20080804171017.GA13725@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804171017.GA13725@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 01:10:17AM +0800, Herbert Xu wrote:
> 
> I don't see why you couldn't do that for the crypto API too
> if you wanted to.  That way it would benefit all crypto users
> rather than just the crc32c (note the extra c) users.

Anyway, the point here is the crc32c is nothing special.  It's
just one out of many algorithms that has/will have hardware
acceleration support.

Rather than doing ad-hoc implementations and optimising that
whenever such a thing pops up, let's spend our effort in creating
a common platform that can be reused.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
