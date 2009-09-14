Return-Path: <linux-kernel-owner+w=401wt.eu-S933651AbZINUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651AbZINUu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756796AbZINUu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:50:58 -0400
Received: from fifo99.com ([67.223.236.141]:58294 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884AbZINUu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:50:57 -0400
Subject: Re: [PATCH] PCI / PCIe portdrv: Fix pcie_portdrv_slot_reset()
From: Daniel Walker <dwalker@fifo99.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
In-Reply-To: <200909142225.11874.rjw@sisk.pl>
References: <200909142225.11874.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 13:51:44 -0700
Message-Id: <1252961504.11643.217.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 22:25 +0200, Rafael J. Wysocki wrote:
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
> ---

No sign off?

Daniel

