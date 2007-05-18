Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbXERMKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbXERMKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 08:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXERMJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 08:09:56 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:17706 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbXERMJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 08:09:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L0gYP5d3CJMkE0Nh/cWxxWoMEhod5Rfuq0zQTI+eBoEwSXq33av5vnvGX4jUbPl4vKd77N2OV5DdjmGaNvWnak7Q1WbOtMu39y8uxYNyPS/zsvyj8Nm8RsjMHDv1iIequ02DTgIZLVH5W/YXiqIsBqBHwISjHvyEHx/79owe78s=
Message-ID: <68676e00705180509s64b737e2k37c5b2e713c96932@mail.gmail.com>
Date: Fri, 18 May 2007 14:09:54 +0200
From: Luca <kronos.it@gmail.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070518031931.GA13048@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com>
	 <20070514173823.GA7137@dreamland.darkstar.lan>
	 <20070515014344.GA8850@gondor.apana.org.au>
	 <20070515185212.GA18783@dreamland.darkstar.lan>
	 <20070518031931.GA13048@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, May 15, 2007 at 08:52:12PM +0200, Luca Tettamanti wrote:
> >
> > CONFIG_CRYPTO_ALGAPI=m
>
> Are you sure you're actually running 2.6.22-rc1? Due to a bug
> in the padlock patch present in 2.6.22-rc1 it shouldn't be
> possible to select ALGAPI as a module.

Well, pretty sure. The OOPS says 2.6.22-rc1-libata-g705962cc-dirty,
git agrees and I've done a full rebuild. The .config is generated
using 'make oldconfig' using the 2.6.21 as baseline, maybe ALGAPI is
coming from there?

Luca
