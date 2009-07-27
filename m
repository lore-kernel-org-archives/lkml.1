Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZG0Sf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZG0Sf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZG0Sfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:35:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44726
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209AbZG0Sfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:35:54 -0400
Date: Mon, 27 Jul 2009 11:36:01 -0700 (PDT)
Message-Id: <20090727.113601.155824883.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/12] drivers/net: Correct redundant test
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0907271813120.2682@ask.diku.dk>
References: <Pine.LNX.4.64.0907271813120.2682@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Mon, 27 Jul 2009 18:13:30 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> res has already been tested.  It seems that this test should be on the
> recently returned value mmio.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied to net-next-2.6
