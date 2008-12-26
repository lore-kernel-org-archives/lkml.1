Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbYLZARw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYLZARw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 19:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYLZARi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 19:17:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54240
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbYLZARi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 19:17:38 -0500
Date: Thu, 25 Dec 2008 16:17:40 -0800 (PST)
Message-Id: <20081225.161740.10052019.davem@davemloft.net>
To: hannes@hanneseder.net
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/27] drivers/net: fix sparse warning: returning
 void-valued expression
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081222191517.11807.20718.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
	<20081222191517.11807.20718.stgit@vmbox.hanneseder.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>
Date: Mon, 22 Dec 2008 20:15:17 +0100

> Fix this sparse warning:
> 
>   drivers/net/niu.c:8850:2: warning: returning void-valued expression
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

Can we just fix sparse not to generate this warning?  It's
marginal, at best.  C++ even explicitly defines this as valid
and last time I brought this up Linus even agreed.

The types match, the function returns void and it is returning a void,
what is the problem?
