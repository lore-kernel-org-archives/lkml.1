Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYH0J1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYH0J1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYH0J04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:26:56 -0400
Received: from ryu.zarb.org ([212.85.153.228]:36470 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYH0J0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:26:55 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2008 05:26:55 EDT
Subject: r8169 regression in 2.6.26.3 vs 2.6.26.2
From: Pascal Terjan <pterjan@mandriva.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Cc: Marcus Sundberg <marcus@ingate.com>
Content-Type: text/plain
Organization: Mandriva
Date: Wed, 27 Aug 2008 11:20:00 +0200
Message-Id: <1219828800.30098.7.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.90-1mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since updating to 2.6.26.3, networking no longer works on Acer Aspire
One.

PCI config is now always filled with ones.

Reverting "r8169: avoid thrashing PCI conf space above
RTL_GIGA_MAC_VER_06" makes it work again.

The device is 10ec:8136

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E
PCI Express Fast Ethernet controller (rev 02)
	Subsystem: Acer Incorporated [ALI] Device 015b
	Flags: bus master, fast devsel, latency 0, IRQ 17
	I/O ports at 3000 [size=256]
	Memory at 31010000 (64-bit, prefetchable) [size=4K]
	Memory at 31000000 (64-bit, prefetchable) [size=64K]
	Expansion ROM at 31020000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 3
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
	Capabilities: [70] Express Endpoint, MSI 01
	Capabilities: [ac] MSI-X: Enable- Mask- TabSize=2
	Capabilities: [cc] Vital Product Data <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 00-00-ff-ff-00-00-00-04
	Kernel driver in use: r8169
	Kernel modules: r8169


