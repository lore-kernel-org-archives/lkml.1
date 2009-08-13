Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZHMFTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZHMFTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 01:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZHMFTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 01:19:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47619
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657AbZHMFTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 01:19:05 -0400
Date: Wed, 12 Aug 2009 22:19:15 -0700 (PDT)
Message-Id: <20090812.221915.265592246.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: zdenek.kabelac@gmail.com, linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] 8139cp : balance dma_map_single vs dma_unmap_single
 pair
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090811194622.GA4268@electric-eye.fr.zoreil.com>
References: <c4e36d110908110621o75ff063ex6d42570ce635a243@mail.gmail.com>
	<20090811194622.GA4268@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Tue, 11 Aug 2009 21:46:22 +0200

> The driver always:
> 1. allocate cp->rx_buf_sz + NET_IP_ALIGN
> 2. map cp->rx_buf_sz
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>

Applied, thanks Francois!

But...

1) I don't expect upstream patches in my work email inbox.

2) Please send networking patches to netdev@vger.kernel.org,
   and if you do that then getting #1 right isn't so critical
   :-)

Thanks again!
