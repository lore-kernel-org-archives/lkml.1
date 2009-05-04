Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZEDLsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZEDLsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 07:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZEDLsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 07:48:09 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:39752 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbZEDLsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 07:48:08 -0400
Date: Mon, 4 May 2009 19:48:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] add infrastructure for ansi_cprng self-tests
Message-ID: <20090504114803.GA5445@gondor.apana.org.au>
References: <200904282127.33190.jarod@redhat.com> <200904282128.14153.jarod@redhat.com> <20090429105501.GE7227@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429105501.GE7227@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 06:55:01AM -0400, Neil Horman wrote:
> On Tue, Apr 28, 2009 at 09:28:13PM -0400, Jarod Wilson wrote:
> > Add some necessary infrastructure to make it possible to run
> > self-tests for ansi_cprng. The bits are likely very specific
> > to the ANSI X9.31 CPRNG in AES mode, and thus perhaps should
> > be named more specifically if/when we grow additional CPRNG
> > support...
> > 
> > Successfully tested against the cryptodev-2.6 tree and a
> > Red Hat Enterprise Linux 5.x kernel with the follow-on
> > patch that adds the actual test vectors.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > 
> Thanks Jarod!
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Both patches applied.  Thanks!

In future this should be moved to user-space where we can perform
more complicated tests such as entropy testing.

Of course we need to finish the user-space API first :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
