Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYJGVYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYJGVYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbYJGVXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:23:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36547
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755287AbYJGVXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:23:47 -0400
Date: Tue, 07 Oct 2008 14:23:23 -0700 (PDT)
Message-Id: <20081007.142323.97501781.davem@davemloft.net>
To: a.p.zijlstra@chello.nl
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no, dlezcano@fr.ibm.com,
       penberg@cs.helsinki.fi, neilb@suse.de
Subject: Re: [PATCH 17/32] net: packet split receive api
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081002131608.749239880@chello.nl>
References: <20081002130504.927878499@chello.nl>
	<20081002131608.749239880@chello.nl>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 02 Oct 2008 15:05:21 +0200

> Add some packet-split receive hooks.
> 
> For one this allows to do NUMA node affine page allocs. Later on these hooks
> will be extended to do emergency reserve allocations for fragments.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

The individual driver changes get a bunch of rejects in the net-next-2.6
tree, and you also missed some drivers such as NIU that also should use
these new interfaces.

So what I did for now was add just the non-driver parts that add the
interfaces themselves.

Thanks!

