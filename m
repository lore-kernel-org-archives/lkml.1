Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZIKTN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZIKTN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbZIKTN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:13:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55823
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001AbZIKTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:13:25 -0400
Date: Fri, 11 Sep 2009 12:13:42 -0700 (PDT)
Message-Id: <20090911.121342.40455624.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 5/8] drivers/net/phy: introduce missing kfree
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0909111821520.10552@pc-004.diku.dk>
References: <Pine.LNX.4.64.0909111821520.10552@pc-004.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Fri, 11 Sep 2009 18:22:09 +0200 (CEST)

> Error handling code following a kzalloc should free the allocated data.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
