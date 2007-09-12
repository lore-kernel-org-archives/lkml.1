Return-Path: <linux-kernel-owner+w=401wt.eu-S1764052AbXILDaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764052AbXILDaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 23:30:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXILD37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 23:29:59 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2955 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932656AbXILD36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 23:29:58 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: eswierk@arastra.com (Ed Swierk)
Subject: Re: [PATCH] Configurable tap interface MTU
Cc: netdev@vger.kernel.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <e6c711510709110742v4d2da644ha63b0a6d47c1230b@mail.gmail.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IVIv8-0003Uc-00@gondolin.me.apana.org.au>
Date: Wed, 12 Sep 2007 11:29:42 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ed Swierk <eswierk@arastra.com> wrote:
> 
> The patch caps the MTU somewhat arbitrarily at 16000 bytes. This is
> slightly lower than the value used by the e1000 driver, so it seems
> like a safe upper limit.

Please make it 65535 without an Ethernet header and 65521
with an Ethernet header.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
