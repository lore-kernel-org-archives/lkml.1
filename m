Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076Ab0AKGus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076Ab0AKGus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 01:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859Ab0AKGur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 01:50:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52199
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372Ab0AKGur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 01:50:47 -0500
Date: Sun, 10 Jan 2010 22:50:55 -0800 (PST)
Message-Id: <20100110.225055.167520274.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, hawk@comx.dk, hadi@cyberus.ca
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100111133109.a191ee64.sfr@canb.auug.org.au>
References: <20100111133109.a191ee64.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 11 Jan 2010 13:31:09 +1100

> Hi all,
> 
> Today's linux-next merge of the net tree got a conflict in include/linux/sysctl.h between commit 28f6aeea3f12d37bd258b2c0d5ba891bff4ec479 ("net: restore ip source validation") from Linus' tree and commit 65324144b50bc7022cc9b6ca8f4a536a957019e3 ("net: RFC3069, private VLAN proxy arp support") from the net tree.

That latter commit is specially in the net-next-2.6 tree not the
net-2.6 tree.

> They both use the same number in an enum...  I fixed it up (see below) and
> can carry the fix (or some other) for a while.

I'll merge net-2.6 into net-next-2.6 to resolve this, thanks!
