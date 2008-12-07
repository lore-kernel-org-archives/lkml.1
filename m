Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYLGLio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYLGLio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 06:38:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYLGLif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 06:38:35 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:51213 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753502AbYLGLie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 06:38:34 -0500
Date: Sun, 7 Dec 2008 19:38:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] crypto: des3_ede: permit weak keys unless
	REQ_WEAK_KEY set
Message-ID: <20081207113828.GD13736@gondor.apana.org.au>
References: <200812041557.49601.jarod@redhat.com> <493942D9.6030807@redhat.com> <20081205152427.GA32475@gondor.apana.org.au> <493A101A.1080500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493A101A.1080500@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 12:39:38AM -0500, Jarod Wilson wrote:
>
> v3: set more appropriate RES flag, also per Herbert.

BTW, please maintain the patch description as you would in the
first submission.  This makes it much easier for me to apply the
patch.  Feel free to summarise changes elsewhere in the email.

> Signed-off-by: Jarod Wilson <jarod@redhat.com>

I tried to apply it but I get

$ git apply ~/p
fatal: corrupt patch at line 29
$ patch -s -p1 < ~/p
patch: **** malformed patch at line 29: u8 *key,

$ 

Please fix it up and resubmit.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
