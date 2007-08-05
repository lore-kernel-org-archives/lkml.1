Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXHERgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXHERgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXHERge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:36:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53683 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbXHERgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:36:33 -0400
Message-ID: <46B60A93.80107@garzik.org>
Date: Sun, 05 Aug 2007 13:36:19 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Muli Ben-Yehuda <muli@il.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, riku.seppala@kymp.net,
       Andy Whitcroft <apw@shadowen.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFT] finish i386 and x86-64 sysdata conversion
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de>	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>	 <200708050140.49590.ak@suse.de>	 <20070805050410.GB4960@rhun.haifa.ibm.com>	 <86802c440708042238h39fa1b4ude2836fd9732213b@mail.gmail.com>	 <20070805075307.GA25890@rhun.haifa.ibm.com>	 <86802c440708050149u4c0ef4d8j7ea3478b07312525@mail.gmail.com>	 <20070805115457.GD19963@rhun.haifa.ibm.com> <86802c440708050939t7853ad74w5f039d1478964857@mail.gmail.com>
In-Reply-To: <86802c440708050939t7853ad74w5f039d1478964857@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> pci_scan_bus_on_node(int bus, struct pci_ops *ops, int node)
> x86_pci_scan_root_bus(int bus)
> {
>   pci_scan_bus_on_node(bus, &pci_root_ops, -1);
> }
> 
> i need node as one param for my patch later in irq.c and legacy.c


It is a mistake to start coding NUMA details into pci scan functions.

Anywhere the current code does not set the NUMA node, set it to -1 or 
some other default value.

	Jeff


