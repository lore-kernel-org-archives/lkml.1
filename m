Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZLND6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZLND6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbZLND6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:58:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34153
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756576AbZLND6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:58:05 -0500
Date: Sun, 13 Dec 2009 19:58:06 -0800 (PST)
Message-Id: <20091213.195806.179955530.davem@davemloft.net>
To: julia@diku.dk
Cc: petkan@users.sourceforge.net, gregkh@suse.de, linux-usb@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb: Correct code taking the size of a
 pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0912131646400.27767@ask.diku.dk>
References: <Pine.LNX.4.64.0912131646400.27767@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 13 Dec 2009 16:47:04 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> sizeof(dev->dev_addr) is the size of a pointer.  A few lines above, the
> size of this field is obtained using netdev->addr_len for a call to memcpy,
> so do the same here.
> 
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
