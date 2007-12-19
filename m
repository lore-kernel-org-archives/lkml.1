Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXLSXGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXLSXGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:06:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXLSXGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:06:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37500
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbXLSXGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:06:23 -0500
Date: Wed, 19 Dec 2007 15:06:22 -0800 (PST)
Message-Id: <20071219.150622.158580703.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       krh@bitplanet.net, linux1394-devel@lists.sourceforge.net
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22 regression)
From: David Miller <davem@davemloft.net>
In-Reply-To: <476947C1.2010405@s5r6.in-berlin.de>
References: <4767A323.7090205@s5r6.in-berlin.de>
	<20071218.142956.26529678.davem@davemloft.net>
	<476947C1.2010405@s5r6.in-berlin.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Wed, 19 Dec 2007 17:33:05 +0100

> drivers/firewire/fw_ohci.c needs them for dma_map_single() +
> dma_sync_single_for_device() in the pci_driver.probe(), sometime after
> it called pci_enable_device(), before finishing the probe.

I'll take a look at this and try to figure out exactly
what might be going wrong.

The dev_archdata should be fully setup at this time.
