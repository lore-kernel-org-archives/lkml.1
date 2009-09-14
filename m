Return-Path: <linux-kernel-owner+w=401wt.eu-S933890AbZINUjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890AbZINUjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZINUjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:39:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:22316 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbZINUjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:39:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,384,1249282800"; 
   d="scan'208";a="550492733"
Date: Mon, 14 Sep 2009 13:39:12 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI / PCIe portdrv: Fix pcie_portdrv_slot_reset()
Message-ID: <20090914133912.6525b0ce@jbarnes-g45>
In-Reply-To: <200909142225.11874.rjw@sisk.pl>
References: <200909142225.11874.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 22:25:11 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> After commit c82f63e411f1b58427c103bd95af2863b1c96dd1
> (PCI: check saved state before restore) pcie_portdrv_slot_reset()
> may not work correctly if dev->error_state is equal to
> pci_channel_io_frozen, because dev->state_saved need not be set at
> that time.  Fix this issue by setting dev->state_saved before
> pci_restore_state() is called in pcie_portdrv_slot_reset().
> 
> From: Rafael J. Wysocki <rjw@sisk.pl>

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
