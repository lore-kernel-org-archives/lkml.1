Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZDUIxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZDUIxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbZDUIwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:52:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44205
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbZDUIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:52:43 -0400
Date: Tue, 21 Apr 2009 01:52:35 -0700 (PDT)
Message-Id: <20090421.015235.23457775.davem@davemloft.net>
To: jon.lin@vatics.com
Cc: dada1@cosmosbay.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.1 1/1] 8139too: fix HW initial flow
From: David Miller <davem@davemloft.net>
In-Reply-To: <0E04AEADD178614A86F3017CC5FA693B4959924809@MS.vivotek.tw>
References: <0E04AEADD178614A86F3017CC5FA693B4959924809@MS.vivotek.tw>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <jon.lin@vatics.com>
Date: Mon, 20 Apr 2009 20:58:01 +0800

> While ifconfig eth0 up kernel calls open() of 8139 driver(8139too.c).
> In rtl8139_hw_start() of rtl8139_open(), 8139 driver enable RX before setting up the DMA buffer address. In this interval where RX was enabled and DMA buffer address is not yet set up, any incoming broadcast packet would be send to a strange physical address:
> 0x003e8800 which is the default value of DMA buffer address.
> Unfortunately, this address is used by Linux kernel. So kernel panics.
> This patch fix it by setting up DMA buffer address before RX enabled and everything is fine even under broadcast packets attack.
> 
> Signed-off-by: Jonathan Lin <jon.lin@vatics.com>

This patch does not apply, it was corrupted by your email client.

I even think it has MS-DOS style newlines in it :-(
