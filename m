Return-Path: <linux-kernel-owner+w=401wt.eu-S1762152AbYBHCKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbYBHCKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYBHCK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:10:29 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45462
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbYBHCK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:10:29 -0500
Date: Thu, 07 Feb 2008 18:11:00 -0800 (PST)
Message-Id: <20080207.181100.226258547.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [IPV6] Minor clenup: remove two unused definitions in
 net/ip6_route.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0802070758j21299257m19e04fffdedd914@mail.gmail.com>
References: <eb3ff54b0802070758j21299257m19e04fffdedd914@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Thu, 7 Feb 2008 17:58:07 +0200

> Remove IP6_RT_PRIO_FW and IP6_RT_FLOW_MASK definitions in
> include/net/ip6_route.h, as they are not used in the kernel.
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Applied.

If you grep for "fc_metric" in the tree you'll see some
explicit uses of the magic constant "1024" which probably
should be replaced with IP6_RT_PRIO_USER.  If you could
verify that and cook up a patch if correct, I'd appreciate
it.

Thanks.
