Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbZKWLzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbZKWLzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZKWLzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:55:51 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:54850 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757273AbZKWLzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:55:50 -0500
Date: Mon, 23 Nov 2009 19:55:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, crypto, Use gas macro for PCLMULQDQ-NI and
	PSHUFB
Message-ID: <20091123115553.GA6424@gondor.apana.org.au>
References: <1257839041.22519.2523.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257839041.22519.2523.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 03:44:01PM +0800, Huang Ying wrote:
> Old binutils do not support PCLMULQDQ-NI and PSHUFB, to make kernel
> can be compiled by them, .byte code is used instead of assembly
> instructions. But the readability and flexibility of raw .byte code is
> not good.
> 
> So corresponding assembly instruction like gas macro is used instead.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Both patches applied.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
