Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYHCVIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYHCVIF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 17:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbYHCVHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 17:07:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33960
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755345AbYHCVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 17:07:51 -0400
Date: Sun, 03 Aug 2008 14:07:51 -0700 (PDT)
Message-Id: <20080803.140751.57839905.davem@davemloft.net>
To: sven.wegener@stealer.net
Cc: marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, den@openvz.org
Subject: Re: [PATCH] net: Add missing extra2 parameter for ip_default_ttl
 sysctl
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0808032214130.29048@titan.stealer.net>
References: <alpine.LNX.1.10.0808032110520.7765@titan.stealer.net>
	<1217793894.8154.38.camel@iris.sw.ru>
	<alpine.LNX.1.10.0808032214130.29048@titan.stealer.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven Wegener <sven.wegener@stealer.net>
Date: Sun, 3 Aug 2008 22:18:59 +0200 (CEST)

> Commit 76e6ebfb40a2455c18234dcb0f9df37533215461 acceses the extra2 parameter of
> the ip_default_ttl ctl_table, but it is never set to a meaningful value. When
> e84f84f276473dcc673f360e8ff3203148bdf0e2 is applied, we'll oops in
> rt_cache_invalidate(). Set extra2 to init_net, to avoid that.
> 
> Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
> Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Acked-by: Denis V. Lunev <den@openvz.org>

Applied, thanks a lot.

Please provide commit header line text when referencing SHA IDs,
as the SHA IDs can change when patches are applied to different
trees.  Here is the actual changelog message I used so you can
see what I mean:

    net: Add missing extra2 parameter for ip_default_ttl sysctl
    
    Commit 76e6ebfb40a2455c18234dcb0f9df37533215461 ("netns: add namespace
    parameter to rt_cache_flush") acceses the extra2 parameter of the
    ip_default_ttl ctl_table, but it is never set to a meaningful
    value. When e84f84f276473dcc673f360e8ff3203148bdf0e2 ("netns: place
    rt_genid into struct net") is applied, we'll oops in
    rt_cache_invalidate(). Set extra2 to init_net, to avoid that.
    
    Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
    Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
    Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
    Acked-by: Denis V. Lunev <den@openvz.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>
