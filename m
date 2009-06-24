Return-Path: <linux-kernel-owner+w=401wt.eu-S1751909AbZFXFnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbZFXFnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 01:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZFXFnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 01:43:07 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:50905 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751234AbZFXFnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 01:43:06 -0400
Date: Wed, 24 Jun 2009 13:43:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: aes-ni - Don't print message with KERN_ERR on
	old system
Message-ID: <20090624054302.GA18950@gondor.apana.org.au>
References: <adaprcuq33j.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaprcuq33j.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 10:20:16AM -0700, Roland Dreier wrote:
> When the aes-intel module is loaded on a system that does not have the
> AES instructions, it prints
> 
>     Intel AES-NI instructions are not detected.
> 
> at level KERN_ERR.  Since aes-intel is aliased to "aes" it will be tried
> whenever anything uses AES and spam the console.  This doesn't match
> existing practice for how to handle "no hardware" when initializing a
> module, so downgrade the message to KERN_INFO.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>

Patch applied.  Thanks Roland!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
