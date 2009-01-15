Return-Path: <linux-kernel-owner+w=401wt.eu-S1764643AbZAOLPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764643AbZAOLPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbZAOLPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:15:41 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:41483 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757911AbZAOLPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:15:40 -0500
Date: Thu, 15 Jan 2009 22:15:37 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mihai =?utf-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: b44 - swapper: page allocation failure
Message-ID: <20090115111537.GA994@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901142034.55090.mihai.dontu@gmail.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mihai Donțu <mihai.dontu@gmail.com> wrote:
> Hi,
> 
> A friend of mine just booted 2.6.28 and when someone else tried to send 
> something to him over ssh (scp), the transfer failed and the following 
> appeared in dmesg:

You missed the all important order line before the stack trace.
If it's order 0, then you're just out of memory, if it's greater
than order 0, then either you're using jumbo frames or b44 is
broken.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
