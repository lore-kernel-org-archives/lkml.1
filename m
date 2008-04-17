Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbYDQEtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbYDQEtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbYDQEtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:49:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:35846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYDQEtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:49:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,668,1199692800"; 
   d="scan'208";a="318052789"
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
From: "Huang, Ying" <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
       "Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
In-Reply-To: <20080417033402.GB3394@gondor.apana.org.au>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
	 <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
	 <1208333949.4322.5.camel@caritas-dev.intel.com>
	 <20080416184016.GA21365@Chamillionaire.breakpoint.cc>
	 <1208397123.4322.21.camel@caritas-dev.intel.com>
	 <20080417033402.GB3394@gondor.apana.org.au>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 17 Apr 2008 12:53:13 +0800
Message-Id: <1208407993.4322.29.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 17 Apr 2008 04:48:52.0600 (UTC) FILETIME=[55B2DF80:01C8A046]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-17 at 11:34 +0800, Herbert Xu wrote:
> On Thu, Apr 17, 2008 at 09:52:03AM +0800, Huang, Ying wrote:
> >
> > As far as I know, the CRYPTO_MINALIGN is defined in
> > include/linux/crypto.h as __alignof__(unsigned long long), and the
> > __crt_ctx in crypto_tfm is aligned in CRYPTO_MINALIGN. So I think adding
> > a pad is sufficient for x86_64 implementation.
> 
> It should be sufficient but it would be better to use an align
> attribute to better document the intention.

OK. I will use the align attribute.

Best Regards,
Huang Ying
