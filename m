Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbZFQLcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbZFQLcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765106AbZFQLcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:32:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57113
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765009AbZFQLcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:32:17 -0400
Date: Wed, 17 Jun 2009 04:32:19 -0700 (PDT)
Message-Id: <20090617.043219.74142763.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: torvalds@linux-foundation.org, mingo@elte.hu, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A37FC93.7070403@gmail.com>
References: <20090616.120829.182011393.davem@davemloft.net>
	<4A37F495.9030101@gmail.com>
	<4A37FC93.7070403@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 16 Jun 2009 22:12:03 +0200

> [PATCH] net: sk_wmem_alloc has initial value of one, not zero
> 
> commit 2b85a34e911bf483c27cfdd124aeb1605145dc80 
> (net: No more expensive sock_hold()/sock_put() on each tx)
> changed initial sk_wmem_alloc value.
> 
> Some protocols check sk_wmem_alloc value to determine if a timer
> must delay socket deallocation. We must take care of the sk_wmem_alloc
> value being one instead of zero when no write allocations are pending.
> 
> Reported by Ingo Molnar, and full diagnostic from David Miller.
> 
> This patch introduces three helpers to get read/write allocations
> and a followup patch will use these helpers to report correct
> write allocations to user.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks Eric.
