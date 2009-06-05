Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbZFEHCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbZFEHCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZFEHCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:02:46 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57388 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843AbZFEHCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:02:45 -0400
Date: Fri, 5 Jun 2009 17:02:40 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [RFC PATCH] crypto: add buffer overflow checks to testmgr
Message-ID: <20090605070240.GA7650@gondor.apana.org.au>
References: <200905291132.55848.jarod@redhat.com> <20090529221055.GA17957@gondor.apana.org.au> <200906041759.37762.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041759.37762.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 05:59:36PM -0400, Jarod Wilson wrote:
> 
> One note... This is actually causing some new compile warnings to be
> spit out, varies from arch to arch, dependent on page size... ppc64
> with 64k pages is the worst offender:
> 
> crypto/testmgr.c: In function 'test_nhash':
> crypto/testmgr.c:194: warning: comparison is always false due to limited range of data type
> crypto/testmgr.c: In function 'test_aead':
> crypto/testmgr.c:374: warning: comparison is always false due to limited range of data type
> crypto/testmgr.c:375: warning: comparison is always false due to limited range of data type
> crypto/testmgr.c: In function 'test_cipher':
> crypto/testmgr.c:676: warning: comparison is always false due to limited range of data type
> crypto/testmgr.c: In function 'test_skcipher':
> crypto/testmgr.c:771: warning: comparison is always false due to limited range of data type

Don't worry, this warning will go away as soon as you move to a
more up-to-date gcc :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
