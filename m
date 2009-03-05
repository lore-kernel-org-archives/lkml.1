Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZCEMAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZCEMAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 07:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZCEMAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 07:00:45 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45615 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbZCEMAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 07:00:45 -0500
Date: Thu, 5 Mar 2009 13:00:41 +0100
From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
To: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] crypto: Add AES-NI support for more modes
Message-ID: <20090305120041.GB4101@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
References: <1236219949.24215.39.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1236219949.24215.39.camel@yhuang-dev.sh.intel.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying | 2009-03-05 10:25:49 [+0800]:

>--- a/crypto/Kconfig
>+++ b/crypto/Kconfig
>@@ -488,6 +488,7 @@ config CRYPTO_AES_NI_INTEL
> 	select CRYPTO_AES_X86_64
> 	select CRYPTO_CRYPTD
> 	select CRYPTO_ALGAPI
>+	select CRYPTO_FPU
> 	help
> 	  Use Intel AES-NI instructions for AES algorithm.
> 
>
Please add that you also accelerate block modes like lrw & xts. A full
list would be nice. There is no direct HW-support for this block modes
where the user could expect this from a marketing paper :)

Sebastian
