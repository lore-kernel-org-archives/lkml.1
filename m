Return-Path: <linux-kernel-owner+w=401wt.eu-S1755467AbZIQR1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbZIQR1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZIQR1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:27:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35539
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbZIQR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:27:17 -0400
Date: Thu, 17 Sep 2009 10:27:35 -0700 (PDT)
Message-Id: <20090917.102735.33788478.davem@davemloft.net>
To: jie.yang@atheros.com
Cc: miles.lane@gmail.com, chris.snook@gmail.com, jcliburn@gmail.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch net-next]atl1e:fix 2.6.31-git4 -- ATL1E 0000:03:00.0:
 DMA-API: device driver frees DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <12530933101782-git-send-email-jie.yang@atheros.com>
References: <12530933101782-git-send-email-jie.yang@atheros.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jie.yang@atheros.com>
Date: Wed, 16 Sep 2009 17:28:30 +0800

> use the wrong API when free dma. So when map dma use a flag to demostrate whether it is 'pci_map_single' or 'pci_map_page'. When free the dma, check the flags to select the right APIs('pci_unmap_single' or 'pci_unmap_page').
> 
> set the flags type to u16  instead of unsigned long  on David's comments.
> 
> Signed-off-by: Jie Yang <jie.yang@atheros.com>

Applied.
