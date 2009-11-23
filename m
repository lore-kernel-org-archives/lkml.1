Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZKWBTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZKWBTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:19:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZKWBTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:19:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34995
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754176AbZKWBTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:19:18 -0500
Date: Sun, 22 Nov 2009 17:19:32 -0800 (PST)
Message-Id: <20091122.171932.74107512.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: linux-next: manual merge of the net tree with the net-current
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091123120052.dd388203.sfr@canb.auug.org.au>
References: <20091123120052.dd388203.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 23 Nov 2009 12:00:52 +1100

> Today's linux-next merge of the net tree got a conflict in
> drivers/ieee802154/fakehard.c between commit
> 56cf54831fd1be105e89a9df899e3b22442da180 ("ieee802154: dont leak skbs in
> ieee802154_fake_xmit()") from the net-current tree and commit
> 8964be4a9a5ca8cab1219bb046db2f6d1936227c ("net: rename skb->iif to
> skb->skb_iif") from the net tree.
> 
> The former removed the code modified by the latter, so I used the former.

Hmmm... I specifically remember taking core of this conflict when I
merged net-next-2.6 into net-2.6 yesterday or the day before.
