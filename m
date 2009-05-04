Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZEDLKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZEDLKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbZEDLKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:10:36 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58177 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754404AbZEDLKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:10:34 -0400
Date: Mon, 4 May 2009 19:10:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: don't raise alarm for no ctr(aes*) tests in
	fips mode
Message-ID: <20090504111010.GA4991@gondor.apana.org.au>
References: <200904282118.22823.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904282118.22823.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:18:22PM -0400, Jarod Wilson wrote:
> Per the NIST AESAVS document, Appendix A[1], it isn't possible to
> have automated self-tests for counter-mode AES, but people are
> misled to believe something is wrong by the message that says there
> is no test for ctr(aes). Simply suppress all 'no test for ctr(aes*'
> messages if fips_enabled is set to avoid confusion.

This is not true at all.  In our implementation the counter is
set through the IV so it definitely is possible to test counter
mode algorithms in Linux.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
