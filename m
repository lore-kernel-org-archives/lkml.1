Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZIPHoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZIPHoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 03:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZIPHog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 03:44:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54005
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbZIPHof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 03:44:35 -0400
Date: Wed, 16 Sep 2009 00:44:52 -0700 (PDT)
Message-Id: <20090916.004452.40084897.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: miles.lane@gmail.com, chris.snook@gmail.com, jcliburn@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch net-next]atl1e:fix 2.6.31-git4 -- ATL1E 0000:03:00.0:
 DMA-API: device driver frees DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <12530857843502-git-send-email-jie.yang@atheros.com>
References: <12530857843502-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Wed, 16 Sep 2009 15:23:04 +0800

> [   25.059969] WARNING: at lib/dma-debug.c:816 check_unmap+0x383/0x55c()
> [   25.059976] Hardware name: 1000HE
> [   25.059984] ATL1E 0000:03:00.0: DMA-API: device driver frees DMA
>      memory with wrong function [device address=0x0000000036b92802]
>      [size=90 bytes] [mapped as single] [unmapped as page]
> 
> use the wrong API when free dma. So when map dma use a flag to 
> demostrate whether it is 'pci_map_single' or 'pci_map_page'. When free 
> the dma, check the flags to select the right APIs('pci_unmap_single' or 'pci_unmap_page').
> 
> set the flags type to u16  instead of unsigned long  on David's comments.
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Your email client has corrupted this patch (turning tab characters
into spaces, etc.) making it unusable.
