Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZIVVU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZIVVU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 17:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZIVVU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 17:20:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33896
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbZIVVU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 17:20:56 -0400
Date: Tue, 22 Sep 2009 14:21:15 -0700 (PDT)
Message-Id: <20090922.142115.139068968.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/net: remove duplicate structure field
 initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0909192148180.27171@ask.diku.dk>
References: <Pine.LNX.4.64.0909192148180.27171@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sat, 19 Sep 2009 21:48:41 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> The definitions of vnet_ops and ehea_netdev_ops have initializations of a
> local function and eth_change_mtu for their respective ndo_change_mtu
> fields.  This change uses only the local function.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
