Return-Path: <linux-kernel-owner+w=401wt.eu-S1761193AbZD2NSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761193AbZD2NSp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760711AbZD2NPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:15:12 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:48787 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760632AbZD2NPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:15:10 -0400
Date: Wed, 29 Apr 2009 21:15:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: catch base cipher self-test failures in fips
	mode
Message-ID: <20090429131506.GA17254@gondor.apana.org.au>
References: <200904282111.52074.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904282111.52074.jarod@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:11:51PM -0400, Jarod Wilson wrote:
>
> +notest:
> +	printk(KERN_INFO "alg: No test for %s (%s)\n", alg, driver);

Can notest ever get here with rc != 0?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
