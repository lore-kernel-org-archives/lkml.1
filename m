Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZFRB5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZFRB5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 21:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbZFRB4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 21:56:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54910
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753094AbZFRB4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 21:56:54 -0400
Date: Wed, 17 Jun 2009 18:56:58 -0700 (PDT)
Message-Id: <20090617.185658.226201750.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: robert.olsson@its.uu.se, zheng.yan@oracle.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/1 v2] Re: [BUG] fib_tries related Oops in 2.6.30
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090615160800.GC2767@ami.dom.local>
References: <20090615065333.GA4378@ff.dom.local>
	<20090615160800.GC2767@ami.dom.local>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Mon, 15 Jun 2009 18:08:01 +0200

> ipv4: Fix fib_trie rebalancing, part 2
> 
> My previous patch, which explicitly delays freeing of tnodes by adding
> them to the list to flush them after the update is finished, isn't
> strict enough. It treats exceptionally tnodes without parent, assuming
> they are newly created, so "invisible" for the read side yet.
> 
> But the top tnode doesn't have parent as well, so we have to exclude
> all exceptions (at least until a better way is found). Additionally we
> need to move rcu assignment of this node before flushing, so the
> return type of the trie_rebalance() function is changed.
> 
> Reported-by: Yan Zheng <zheng.yan@oracle.com>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>

Applied, thanks a lot Jarek.
