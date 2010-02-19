Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0BSVRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:17:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35615
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab0BSVRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:17:02 -0500
Date: Fri, 19 Feb 2010 13:17:18 -0800 (PST)
Message-Id: <20100219.131718.115496278.davem@davemloft.net>
To: hancockrwd@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, romieu@fr.zoreil.com
Subject: Re: [PATCH 2.6.34] r8169: enable 64-bit DMA by default for PCI
 Express devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B7CAEC1.6090408@gmail.com>
References: <4B7CAEC1.6090408@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Hancock <hancockrwd@gmail.com>
Date: Wed, 17 Feb 2010 21:06:41 -0600

> Currently use of 64-bit DMA is disabled in r8169 unless the user passes the
> use_dac module option. This is reasonable for conventional PCI devices where
> broken chipsets may not handle dual-address-cycle transfers properly for
> 32-bit slots and so this may not be safe. However, PCI Express should not have
> this problem and not using 64-bit DMA results in DMA transfers needlessly using
> the IOMMU or SWIOTLB. Set the use_dac module parameter to a new default value of
> -1 which results in 64-bit DMA being enabled by default for PCI Express devices
> only.
> 
> Signed-off-by: Robert Hancock <hancockrwd@gmail.com>

This patch is fine, but it doesn't apply cleanly to net-next-2.6

Please fix this up and resubmit, thanks!
