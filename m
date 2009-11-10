Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZKJC7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZKJC7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZKJC7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:59:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:17434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZKJC7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:59:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,712,1249282800"; 
   d="scan'208";a="209604974"
Subject: Re: [PATCH 2/2] x86, crypto, Use gas macro for AES-NI instructions
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20091109185609.GB9588@gondor.apana.org.au>
References: <1257403457.22519.250.camel@yhuang-dev.sh.intel.com>
	 <20091109185609.GB9588@gondor.apana.org.au>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 10:59:11 +0800
Message-Id: <1257821951.22519.2415.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-10 at 02:56 +0800, Herbert Xu wrote: 
> On Thu, Nov 05, 2009 at 02:44:17PM +0800, Huang Ying wrote:
> > Old binutils do not support AES-NI instructions, to make kernel can be
> > compiled by them, .byte code is used instead of AES-NI assembly
> > instructions. But the readability and flexibility of raw .byte code is
> > not good.
> > 
> > So corresponding assembly instruction like gas macro is used instead.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> Sorry, but this doesn't apply:
> 
> $ git apply ~/p
> fatal: patch fragment without header at line 428: @@ -518,51 +417,37 @@ _aesni_dec1:
> $

Sorry, I will re-sent this.

Best Regards,
Huang Ying


