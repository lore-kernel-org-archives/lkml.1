Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbZKIS4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbZKIS4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZKIS4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:56:17 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:34418 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751814AbZKIS4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:56:16 -0500
Date: Mon, 9 Nov 2009 13:56:10 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, crypto, Use gas macro for AES-NI instructions
Message-ID: <20091109185609.GB9588@gondor.apana.org.au>
References: <1257403457.22519.250.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257403457.22519.250.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 02:44:17PM +0800, Huang Ying wrote:
> Old binutils do not support AES-NI instructions, to make kernel can be
> compiled by them, .byte code is used instead of AES-NI assembly
> instructions. But the readability and flexibility of raw .byte code is
> not good.
> 
> So corresponding assembly instruction like gas macro is used instead.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Sorry, but this doesn't apply:

$ git apply ~/p
fatal: patch fragment without header at line 428: @@ -518,51 +417,37 @@ _aesni_dec1:
$

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
