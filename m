Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbZHMETY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbZHMETY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 00:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZHMETU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 00:19:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43280
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751060AbZHMETS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 00:19:18 -0400
Date: Wed, 12 Aug 2009 21:19:29 -0700 (PDT)
Message-Id: <20090812.211929.101928561.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/net: Correct use of
 request_region/request_mem_region
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0908090943210.13271@ask.diku.dk>
References: <Pine.LNX.4.64.0908090943210.13271@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 9 Aug 2009 09:43:42 +0200 (CEST)

> From: Julia Lawall <julia@diku.dk>
> 
> request_mem_region should be used with release_mem_region, not request_region.
> 
> The semantic patch that fixes this problem is as follows:
> (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
