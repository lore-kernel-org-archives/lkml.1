Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbXIJI7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbXIJI7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 04:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXIJI7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 04:59:34 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4123 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751130AbXIJI7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 04:59:33 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: hjk@linutronix.de (Hans-J??rgen Koch)
Subject: Re: [PATCH resend] Fix a lock problem in generic phy code
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jeff@garzik.org,
       afleming@freescale.com
Organization: Core
In-Reply-To: <200709092336.25634.hjk@linutronix.de>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1IUf6h-0006qu-00@gondolin.me.apana.org.au>
Date: Mon, 10 Sep 2007 16:58:59 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-J??rgen Koch <hjk@linutronix.de> wrote:
>
> The following patch fixes it. Tested on an AT91SAM9263-EK board, kernel 2.6.23-rc4 and -rc3-mm1.

Could you please audit all instances of physdev->lock and add
_bh where necessary?  I can see that at least phys_stop also
needs the _bh.

We should also consider whether it makes sense to move the
timer into a work queue.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
