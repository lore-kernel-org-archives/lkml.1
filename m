Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbZDTKPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbZDTKPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 06:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbZDTKOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 06:14:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51794
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbZDTKOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:14:50 -0400
Date: Mon, 20 Apr 2009 03:14:39 -0700 (PDT)
Message-Id: <20090420.031439.55595103.davem@davemloft.net>
To: tzungder@gmail.com
Cc: dada1@cosmosbay.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow
From: David Miller <davem@davemloft.net>
In-Reply-To: <528f811a0904191854o3a354e8fif6a8d65f8da94965@mail.gmail.com>
References: <528f811a0904190316v22621684o3047e37bf8e78bda@mail.gmail.com>
	<528f811a0904191854o3a354e8fif6a8d65f8da94965@mail.gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tzungder Lin <tzungder@gmail.com>
Date: Mon, 20 Apr 2009 09:54:10 +0800

> From: Jonathan Lin <tzungder@gmail.com>
> 
> While ifconfig eth0 up kernel calls open() of 8139 driver(8139too.c).
> In rtl8139_hw_start() of rtl8139_open(), 8139 driver enable RX before
> setting up the DMA buffer address. In this interval where RX was
> enabled and DMA buffer address is not yet set up, any incoming
> broadcast packet would be send to a strange physical address:
> 0x003e8800 which is the default value of DMA buffer address.
> Unfortunately, this address is used by Linux kernel. So kernel panics.
> This patch fix it by setting up DMA buffer address before RX enabled
> and everything is fine even under broadcast packets attack.
> 
> Signed-off-by: Jonathan Lin <tzungder@gmail.com>

Your email client corrupted this patch, breaking up long lines
and substituting tabs with space characters among other things.

Please fix this up and resubmit.

I would suggest trying to send the patch to yourself and then trying
to apply what arrives in your inbox, just as I would.

Thanks.
