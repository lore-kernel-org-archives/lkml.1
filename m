Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbXJGVFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbXJGVFs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbXJGVFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:05:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35004
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752054AbXJGVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 17:05:41 -0400
Date: Sun, 07 Oct 2007 14:05:38 -0700 (PDT)
Message-Id: <20071007.140538.115926189.davem@davemloft.net>
To: hannes-kernel@saeurebad.de
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org
Subject: Re: [TRIVIAL PATCH] Remove unused variable in drivers/dma/ioatdma.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071007191849.GA30018@saeurebad.de>
References: <20071007191849.GA30018@saeurebad.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Weiner <hannes-kernel@saeurebad.de>
Date: Sun, 7 Oct 2007 21:18:49 +0200

> Hi,
> 
> I found this in an `allyesconfig' build:
> 
>   CC      drivers/dma/ioatdma.o
>   drivers/dma/ioatdma.c: In function #ioat_dma_free_chan_resources#:
>   drivers/dma/ioatdma.c:247: warning: unused variable #chanctrl#
> 
> 	Hannes
> 
> Signed-off-by: Johannes Weiner <hannes-kernel@saeurebad.de>

This exists as a patch in -mm for what seems like months.

I can't believe this one-liner hasn't been merged yet, it's
silly.

I was even chastised at one point for merging it into my net-2.6.24
tree :-)
