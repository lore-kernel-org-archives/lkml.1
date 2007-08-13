Return-Path: <linux-kernel-owner+w=401wt.eu-S1033081AbXHMU76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033081AbXHMU76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031552AbXHMU6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:58:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37530
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966422AbXHMU6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:58:12 -0400
Date: Mon, 13 Aug 2007 13:58:11 -0700 (PDT)
Message-Id: <20070813.135811.06543390.davem@davemloft.net>
To: divy@chelsio.com
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Subject: Re: [PATCH 2.6.23] cxgb3 - Fix dev->priv usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070813193303.15321.49171.stgit@speedy5>
References: <20070813193303.15321.49171.stgit@speedy5>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Mon, 13 Aug 2007 12:33:04 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> cxgb3 used netdev_priv() and dev->priv for different purposes.
> In 2.6.23, netdev_priv() == dev->priv, cxgb3 needs a fix.
> This patch is a partial backport of Dave Miller's changes in the 
> net-2.6.24 git branch. 
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Thank you for doing this backport.
