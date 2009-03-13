Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbZCMSyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbZCMSyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 14:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZCMSx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 14:53:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48257
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbZCMSx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 14:53:56 -0400
Date: Fri, 13 Mar 2009 11:53:42 -0700 (PDT)
Message-Id: <20090313.115342.89774843.davem@davemloft.net>
To: daniel@caiaq.de
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org, ben@simtec.co.uk
Subject: Re: [PATCH] drivers/net/ax88796.c: take IRQ flags from
 platform_device
From: David Miller <davem@davemloft.net>
In-Reply-To: <1236955851-14763-1-git-send-email-daniel@caiaq.de>
References: <1236955851-14763-1-git-send-email-daniel@caiaq.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <daniel@caiaq.de>
Date: Fri, 13 Mar 2009 15:50:51 +0100

> This patch adds support to the ax88796 ethernet driver to take IRQ flags
> given by the platform_device definition.
> 
> The patch depends on the platform_get_irq_flags() function which I added
> in a patch posted here:
> 
> 	http://lkml.org/lkml/2009/3/13/267
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>

Few things:

1) Send networking patches to netdev@vger.kernel.org, not linux-net
   which is for user questions.

2) That platform_get_irq_flags() does not exist in any of the networking
   trees so I cannot apply this.
