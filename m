Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbXIPTW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbXIPTW6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXIPTWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:22:45 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:54352
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbXIPTWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:22:44 -0400
Date: Sun, 16 Sep 2007 12:22:17 -0700 (PDT)
Message-Id: <20070916.122217.68050499.davem@davemloft.net>
To: eswierk@arastra.com
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configurable tap interface MTU
From: David Miller <davem@davemloft.net>
In-Reply-To: <e6c711510709120954i29a8f86bg9ea7bb337a039b5a@mail.gmail.com>
References: <e6c711510709110742v4d2da644ha63b0a6d47c1230b@mail.gmail.com>
	<E1IVIv8-0003Uc-00@gondolin.me.apana.org.au>
	<e6c711510709120954i29a8f86bg9ea7bb337a039b5a@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ed Swierk" <eswierk@arastra.com>
Date: Wed, 12 Sep 2007 09:54:35 -0700

> On 9/11/07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > Please make it 65535 without an Ethernet header and 65521
> > with an Ethernet header.
> 
> Here is a revised patch that allows MTUs up to 65535 for tap
> interfaces and up to 65521 for tun interfaces.
> 
> (If I set the MTU to 65521 on a tun interface, ping complains "message
> too long" when I send a 65521-byte packet; 65520 works okay, though.)

Applied to net-2.6.24

Please provide a proper Signed-off-by: line and a full
changelog with every patch submission and revision in
the future.

Thanks.

