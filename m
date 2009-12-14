Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZLND5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZLND5W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 22:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbZLND5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 22:57:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34136
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbZLND5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 22:57:20 -0500
Date: Sun, 13 Dec 2009 19:57:19 -0800 (PST)
Message-Id: <20091213.195719.246515608.davem@davemloft.net>
To: julia@diku.dk
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/9] drivers/atm: Correct code taking the size of a
 pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0912131240400.24267@ask.diku.dk>
References: <Pine.LNX.4.64.0912131240400.24267@ask.diku.dk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Sun, 13 Dec 2009 12:40:55 +0100 (CET)

> From: Julia Lawall <julia@diku.dk>
> 
> sizeof(TstSchedTbl) is just the size of the pointer.  Change it to the size
> of the referenced data.
> 
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <julia@diku.dk>

Applied.
