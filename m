Return-Path: <linux-kernel-owner+w=401wt.eu-S1760655AbXEJLch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbXEJLch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbXEJLca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:32:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49159
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757474AbXEJLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:32:30 -0400
Date: Thu, 10 May 2007 04:32:33 -0700 (PDT)
Message-Id: <20070510.043233.08323827.davem@davemloft.net>
To: maheshk@cdac.in
Cc: linux-kernel@vger.kernel.org, kernelnewbies@nl.linux.org
Subject: Re: [HOWTO] accessing the DMA mapped data
From: David Miller <davem@davemloft.net>
In-Reply-To: <4642FFA7.4040303@cdac.in>
References: <4642D095.6070305@cdac.in>
	<20070510.014751.74749340.davem@davemloft.net>
	<4642FFA7.4040303@cdac.in>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh <maheshk@cdac.in>
Date: Thu, 10 May 2007 16:49:03 +0530

> I think you have not understood my question properly. My problem is, the 
> layer above the driver will do
> dma_map_single on a kmalloc'ed buffer and passes the result  (bus 
> address) to the device driver. Now
> the driver has to modify the contents of the the original buffer.
> Is it possible to do that ??

You haven't given an example of where this might actually happen.

The driver is where the DMA mappings almost always occur because
that is the layer that knows the bus technology and therefore
the correct DMA interfaces to call.

What kind of driver do you have and what is this upper layer
doing the mappings for you but not giving you a pointer to
the kernel buffer as well?
