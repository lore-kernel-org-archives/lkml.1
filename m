Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYIUJR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYIUJR0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 05:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYIUJRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 05:17:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46633
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYIUJRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 05:17:15 -0400
Date: Sun, 21 Sep 2008 02:17:02 -0700 (PDT)
Message-Id: <20080921.021702.37632261.davem@davemloft.net>
To: James@superbug.co.uk
Cc: herbert@gondor.apana.org.au, dwalker@mvista.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
From: David Miller <davem@davemloft.net>
In-Reply-To: <48D6104B.9040304@superbug.co.uk>
References: <E1KhI4n-0002Fk-7C@gondolin.me.apana.org.au>
	<48D6104B.9040304@superbug.co.uk>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Courtier-Dutton <James@superbug.co.uk>
Date: Sun, 21 Sep 2008 10:13:47 +0100

> Why do you have to preserve packet ordering?
> TCP/IP does not preserve packet ordering across the network.

Yes, but we should preserve per-flow ordering as much as
possible within the local system for optimal performance.

Things fall apart completely, even with TCP, once you reorder more
than 2 or 3 packets deep.

> Sharing the sliding window between CPUs might be interesting!

Again, Steffen's patches take care of this issue.
