Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbZCOL1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbZCOL1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 07:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZCOL1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 07:27:41 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:42344 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZCOL1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 07:27:40 -0400
Date: Sun, 15 Mar 2009 12:27:35 +0100
From: Daniel Mack <daniel@caiaq.de>
To: David Miller <davem@davemloft.net>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org, ben@simtec.co.uk
Subject: Re: [PATCH] drivers/net/ax88796.c: take IRQ flags from
	platform_device
Message-ID: <20090315112735.GC27915@buzzloop.caiaq.de>
References: <1236955851-14763-1-git-send-email-daniel@caiaq.de> <20090313.115342.89774843.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313.115342.89774843.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(the reverse-DNS check is disabled now, sorry for the trouble)

On Fri, Mar 13, 2009 at 11:53:42AM -0700, David Miller wrote:
> > This patch adds support to the ax88796 ethernet driver to take IRQ flags
> > given by the platform_device definition.
> > 
> > The patch depends on the platform_get_irq_flags() function which I added
> > in a patch posted here:
> > 
> > 	http://lkml.org/lkml/2009/3/13/267
> > 
> > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> 
> Few things:
> 
> 1) Send networking patches to netdev@vger.kernel.org, not linux-net
>    which is for user questions.

Ok, wasn't aware of that, sorry.

> 2) That platform_get_irq_flags() does not exist in any of the networking
>    trees so I cannot apply this.

Jep, the other one would need to me merged first. Could you ack on the
patch[*] in case you're fine with it?

Thanks,
Daniel

[*] http://lkml.org/lkml/2009/3/13/267

