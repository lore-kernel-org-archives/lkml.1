Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYIPSKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYIPSKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYIPSKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:10:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620AbYIPSKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:10:22 -0400
Date: Tue, 16 Sep 2008 14:09:17 -0400
From: Rik van Riel <riel@redhat.com>
To: "Michael Chan" <mchan@broadcom.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5-mm1
Message-ID: <20080916140917.105adc2a@bree.surriel.com>
In-Reply-To: <1221519658.11021.13.camel@HP1>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
	<20080915180130.10995b90@cuia.bos.redhat.com>
	<1221519658.11021.13.camel@HP1>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 16:00:58 -0700
"Michael Chan" <mchan@broadcom.com> wrote:

> > 05:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> > 09:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
> 
> Does dmesg show anything when you run ifup?
 
The linux-next tree fails in the same way.  Here is the dmesg output
from the broadcom driver:

Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.8.0 (Aug 14, 2008)
vendor=8086 device=2690
bnx2 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16

eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at
 mem f8000000, IRQ 16, node addr 00:19:b9:ee:6c:4a
vendor=8086 device=3510
vendor=8086 device=3500
vendor=8086 device=25e2
bnx2 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B2) PCI-X 64-bit 133MHz found at mem f4000000, IRQ 17, node addr 00:19:b9:ee:6c:4c
vendor=8086 device=350c
vendor=8086 device=25e2

Here is the dmesg from around ifup time:

lo: Disabled Privacy Extensions
ip used greatest stack depth: 4296 bytes left
try to get more irq_cfg 32
irq_irq ==> [0x434f14800 - 0x434f14e00]
found new irq_cfg for irq 5243136
try to get more irq_desc 32
irq_desc ==> [0x42f426000 - 0x42f428000]
kstat_irqs ==> [0x43c1d4c00 - 0x43c1d5000]
found new irq_desc for irq 5243136

This one might be related, not sure:

pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.

-- 
All rights reversed.
