Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbXJ3WpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbXJ3WpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbXJ3WpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:45:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40302
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752746AbXJ3WpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:45:07 -0400
Date: Tue, 30 Oct 2007 15:44:51 -0700 (PDT)
Message-Id: <20071030.154451.128207404.davem@davemloft.net>
To: jbarnes@virtuousgeek.org
Cc: torvalds@linux-foundation.org, arjan@infradead.org, hancockr@shaw.ca,
       greg@kroah.com, akpm@linux-foundation.org, ak@suse.de,
       rajesh.shah@intel.com, linux-kernel@vger.kernel.org
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710301531.58957.jbarnes@virtuousgeek.org>
References: <200710301504.36972.jbarnes@virtuousgeek.org>
	<alpine.LFD.0.999.0710301518570.30120@woody.linux-foundation.org>
	<200710301531.58957.jbarnes@virtuousgeek.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 30 Oct 2007 15:31:57 -0700

> I don't disagree there.  I'm just saying the actual mechanism is fine 
> (as illustrated by the numerous non-PC ports of Linux), and this 
> particular problem, at least, isn't really specific to how MMCONFIG is 
> described or configured by the firmware and OS, it's simply a Linux 
> problem.

I totally disagree, it is not a Linux problem.

The non-PC ports don't have this issue because the PCI config space
MMIO area of the PCI controller does not overlap PCI MMIO space at
all.  So the problem simply cannot happen.

They choose to put this MMCONFIG in an area overlapping with PCI MMIO
space, which breaks both existing practice and code.
