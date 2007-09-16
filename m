Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbXIPVmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbXIPVmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXIPVmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:42:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52309
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752991AbXIPVmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:42:31 -0400
Date: Sun, 16 Sep 2007 14:42:30 -0700 (PDT)
Message-Id: <20070916.144230.122618434.davem@davemloft.net>
To: jesper.juhl@gmail.com
Cc: linux-kernel@vger.kernel.org, shannon.nelson@intel.com,
       christopher.leech@intel.com
Subject: Re: [PATCH] Remove an unused variable from the Intel I/OAT DMA
 engine driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <200709162331.50784.jesper.juhl@gmail.com>
References: <200709162331.50784.jesper.juhl@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Sun, 16 Sep 2007 23:31:50 +0200

> 
> The 'u16 chanctrl' variable in 
> drivers/dma/ioatdma.c::ioat_dma_free_chan_resources() is completely 
> unused and gcc quite rightfully warns about it:
> 
>   drivers/dma/ioatdma.c:247: warning: unused variable 'chanctrl'
> 
> This patch removes the unused variable and silences the warning.
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Applied to net-2.6.24, thanks Jesper.
