Return-Path: <linux-kernel-owner+w=401wt.eu-S1764493AbXGKADe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764493AbXGKADe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764257AbXGKABR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:01:17 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38444 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762010AbXGKABA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:01:00 -0400
Date: Tue, 10 Jul 2007 16:52:19 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 0/5] more about numa_node with struct device
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, rientjes@google.com,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200707101652.20613.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

these are revised or new patch with numa_node in struct device in addition to 

andrew already sent to andi
x86_64-get-mp_bus_to_node-as-early.patch
it will make all pci_dev->dev.numa_node correctly.

still in -mm, and andrew will re-review for 2.6.23
dma-make-dma-pool-to-use-kmalloc_node.patch

in greg tree
usb-make-the-usb_device-numa_node-get-assigned-from-controller.patch

Thanks

Yinghai Lu
