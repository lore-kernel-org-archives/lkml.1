Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZGGDcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZGGDcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 23:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZGGDbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 23:31:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:53212 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbZGGDbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 23:31:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,360,1243839600"; 
   d="scan'208";a="705541978"
Subject: Re: [RFC 7/7] crypto: Add PCLMULQDQ accelerated GHASH
 implementation
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
In-Reply-To: <20090621135121.GA3153@gondor.apana.org.au>
References: <20090621135121.GA3153@gondor.apana.org.au>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 11:31:52 +0800
Message-Id: <1246937512.5282.99.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Herbert,

On Sun, 2009-06-21 at 21:51 +0800, Herbert Xu wrote:
> Huang Ying <ying.huang@intel.com> wrote:
> > PCLMULQDQ is used to accelerate the most time-consuming part of GHASH,
> > carry-less multiplication. More information about PCLMULQDQ can be
> > found at:
> > 
> > http://software.intel.com/en-us/articles/carry-less-multiplication-and-its-usage-for-computing-the-gcm-mode/
> > 
> > Because PCLMULQDQ changes XMM state, its usage must be enclosed with
> > kernel_fpu_begin/end, which can be used only in process context, the
> > acceleration is implemented as crypto_ahash. That is, request in soft
> > IRQ context will be deferred to the cryptd kernel thread.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> All good.
> 
> So once we fully convert everything to shash, this series can
> go in with the minor changes mentioned in this thread.

What's your plan to convert everything to shash? For 2.6.32? How about
the progress? What can I do to help?

Best Regards,
Huang Ying


