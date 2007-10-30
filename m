Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXJ3HpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXJ3HpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXJ3HpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:45:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752958AbXJ3HpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:45:05 -0400
Date: Tue, 30 Oct 2007 00:44:46 -0700 (PDT)
Message-Id: <20071030.004446.219023926.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rpc_rdma: we need to cast u64 to unsigned long long
 for printing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071030161240.bc81cad3.sfr@canb.auug.org.au>
References: <20071030161240.bc81cad3.sfr@canb.auug.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 30 Oct 2007 16:12:40 +1100

> as some architectures have unsigned long for u64.
> 
> net/sunrpc/xprtrdma/rpc_rdma.c: In function 'rpcrdma_create_chunks':
> net/sunrpc/xprtrdma/rpc_rdma.c:222: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
> net/sunrpc/xprtrdma/rpc_rdma.c:234: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
> net/sunrpc/xprtrdma/rpc_rdma.c: In function 'rpcrdma_count_chunks':
> net/sunrpc/xprtrdma/rpc_rdma.c:577: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'u64
> 
> Noticed on PowerPC pseries_defconfig build.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I've applied this, thanks Stephen.
