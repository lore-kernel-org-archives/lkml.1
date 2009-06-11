Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbZFKJvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbZFKJvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 05:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761725AbZFKJvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 05:51:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35560
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760643AbZFKJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 05:51:41 -0400
Date: Thu, 11 Jun 2009 02:51:43 -0700 (PDT)
Message-Id: <20090611.025143.72222412.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, akpm@odsl.org
Subject: Re: [PATCH net-next] cxgb3: remove __GFP_NOFAIL usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090610092521.8871.39255.stgit@speedy5>
References: <20090610092521.8871.39255.stgit@speedy5>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Wed, 10 Jun 2009 02:25:21 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Pre-allocate a skb at init time to be used for control messages to the HW
> if skb allocation fails.
> 
> Tolerate failures to send messages initializing some memories at the cost of
> parity error detection for these memories.
> Retry sending connection id release messages if both alloc_skb(GFP_ATOMIC)
> and alloc_skb(GFP_KERNEL) fail.
> Do not bring the interface up if messages binding queue set to port fail to
> be sent.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
