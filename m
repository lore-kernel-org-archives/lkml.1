Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXJ1BZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXJ1BZS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 21:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXJ1BZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 21:25:05 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3305 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751968AbXJ1BZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 21:25:04 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: adobriyan@gmail.com (Alexey Dobriyan)
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Cc: jengelh@computergmbh.de, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <20071027202449.GF9816@martell.zuzino.mipt.ru>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IlwtS-0007C8-00@gondolin.me.apana.org.au>
Date: Sun, 28 Oct 2007 09:24:46 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
>        irq_flags_t flags;
> 
>        flags = spin_lock_irqXXX(&lock);
>        spin_unlock_irqYYY(&lock, flags);
> 
> where XXX and YYY are still to be found good names :^) It's also a solution

How about flags?

	flags = spin_lock_irqflags(&lock);
	spin_unlock_irqflags(&lock, flags);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
