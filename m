Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYLGQde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYLGQde (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 11:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYLGQd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 11:33:26 -0500
Received: from tservice.ru ([195.178.208.66]:58881 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbYLGQdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 11:33:25 -0500
Date: Sun, 7 Dec 2008 19:33:24 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207163323.GB31838@ioremap.net>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081207155507.GA15355@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 07, 2008 at 11:55:07PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> Having said that I think this patch should remove this particular
> trigger.  Unfortunately I couldn't find a more succinct way of
> expressing this relationship: if ALGAPI is built-in because it's
> selected by an algorithm, and CRYPTO_MANAGER is enabled then we
> require CRYPTO_MANAGER to be built-in as well.
> 
> Evgeniy, please let me know whether this fixes the problem.

Holy shit... This looks 'excellent' :)

I will try it tomorrow and report back the results.

-- 
	Evgeniy Polyakov
