Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbXA0DMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbXA0DMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 22:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXA0DMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 22:12:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45637
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752169AbXA0DMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 22:12:37 -0500
Date: Fri, 26 Jan 2007 19:12:36 -0800 (PST)
Message-Id: <20070126.191236.41877838.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, deweerdt@free.fr,
       netdev@vger.kernel.org, frederik.deweerdt@gmail.com,
       shemminger@osdl.org
Subject: Re: + oops-in-drivers-net-shaperc.patch added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070127010146.GA18851@gondor.apana.org.au>
References: <20070125.193128.39155864.davem@davemloft.net>
	<E1HAbgn-00039h-00@gondolin.me.apana.org.au>
	<20070127010146.GA18851@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Sat, 27 Jan 2007 12:01:46 +1100

> In fact, the shaper device doesn't even seem to take a ref count of
> the device it has attached to.  So that device can go away at any time.
> What's more, there are drivers that can change hard_header at run-time
> (s390).

Indeed, it needs to do refcounting or something here, at a minimum,
this driver is so buggy and full of problems :-/

Thankfully it's marked OBSOLETE so we'll get rid of it eventually :)
