Return-Path: <linux-kernel-owner+w=401wt.eu-S1031124AbXECKR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031124AbXECKR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031153AbXECKR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:17:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45157
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031141AbXECKR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:17:27 -0400
Date: Thu, 03 May 2007 03:17:27 -0700 (PDT)
Message-Id: <20070503.031727.52094183.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: xemul@sw.ru, netdev@vger.kernel.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, devel@openvz.org, kaber@trash.net,
       dev@openvz.org
Subject: Re: [NETLINK] Don't attach callback to a going-away netlink socket
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070502041222.GA28620@gondor.apana.org.au>
References: <E1HeM9f-0001Dt-00@gondolin.me.apana.org.au>
	<20070428.231849.59657032.davem@davemloft.net>
	<20070502041222.GA28620@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 2 May 2007 14:12:22 +1000

> Dave, thanks for reminding me.  Here it is.
> 
> [NETLINK]: Kill CB only when socket is unused
> 
> Since we can still receive packets until all references to the
> socket are gone, we don't need to kill the CB until that happens.
> This also aligns ourselves with the receive queue purging which
> happens at that point.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks Herbert.
