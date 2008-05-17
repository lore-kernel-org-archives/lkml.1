Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYEQGp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYEQGp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 02:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYEQGpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 02:45:14 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42596 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751802AbYEQGpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 02:45:13 -0400
Date: Sat, 17 May 2008 14:43:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       virtualization@lists.linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
Message-ID: <20080517064307.GA16857@gondor.apana.org.au>
References: <482C8595.5030509@garzik.org> <200805171446.39814.rusty@rustcorp.com.au> <482E6417.8040602@zytor.com> <200805171628.03801.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805171628.03801.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 04:28:03PM +1000, Rusty Russell wrote:
>
> But you did not address the DoS question: can we ignore it?  Or are we trading 
> off a DoS in the host against a potential security weakness in the guest?

Why not do both? Use the host's urandom to make the guest at least
unpredictable on start-up without increasing the guest's entropy,
and use the host's random to actually increase the guest's entropy.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
