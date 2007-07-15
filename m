Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbXGOGsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbXGOGsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 02:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXGOGsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 02:48:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53343
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbXGOGsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 02:48:37 -0400
Date: Sat, 14 Jul 2007 23:48:39 -0700 (PDT)
Message-Id: <20070714.234839.34761809.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: torvalds@linux-foundation.org, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Crypto Update for 2.6.23
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070711130849.GA10494@gondor.apana.org.au>
References: <20070711130849.GA10494@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 11 Jul 2007 21:08:49 +0800

> Here is the crypto update for 2.6.23:
> 
> Please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
> 
> or
> 
> master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

I merged this into my net-2.6 tree, there was a tiny conflict
in crypto/Kconfig I had to resolve because of the async_tx
stuff that went in upstream.

Herbert can you contact the async_tx author to make sure that
his crypto/ bits go through you in the future so that conflicts
like this can be avoided?

Thanks.
