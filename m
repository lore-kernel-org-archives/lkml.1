Return-Path: <linux-kernel-owner+w=401wt.eu-S935723AbXJPUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935723AbXJPUgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761542AbXJPUgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:36:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:27117 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbXJPUf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="347928656"
Date: Tue, 16 Oct 2007 13:29:41 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Mark Lord <lkml@rtr.ca>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
Message-Id: <20071016132941.69d9050f.kristen.c.accardi@intel.com>
In-Reply-To: <47150565.5090102@rtr.ca>
References: <4714C0A6.1030204@rtr.ca>
	<4714D700.7060008@rtr.ca>
	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>
	<47150565.5090102@rtr.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 14:39:33 -0400
Mark Lord <lkml@rtr.ca> wrote:

> Another thing:  if a card is already in the slot before pciehp is loaded
> (under any circumstances), then pciehp does *not* see the card until I
> unplug/replug it.

One other thing to note here, the proper operation of hot plug dictates that
if you boot your laptop with no adapter in the slot, you must first load
the driver in order for the new adapter interrupt to be captured.  So,
if you insert a card without the driver loaded, it will not be enumerated
by PCI until you remove it and the reinsert it.
