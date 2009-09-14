Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZINVC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZINVC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbZINVC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:02:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55325 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184AbZINVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:02:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH] PCI / PCIe portdrv: Fix pcie_portdrv_slot_reset()
Date: Mon, 14 Sep 2009 23:03:26 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200909142225.11874.rjw@sisk.pl> <1252961504.11643.217.camel@desktop>
In-Reply-To: <1252961504.11643.217.camel@desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200909142303.26206.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 September 2009, Daniel Walker wrote:
> On Mon, 2009-09-14 at 22:25 +0200, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > After commit c82f63e411f1b58427c103bd95af2863b1c96dd1
> > (PCI: check saved state before restore) pcie_portdrv_slot_reset()
> > may not work correctly if dev->error_state is equal to
> > pci_channel_io_frozen, because dev->state_saved need not be set at
> > that time.  Fix this issue by setting dev->state_saved before
> > pci_restore_state() is called in pcie_portdrv_slot_reset().
> > 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> 
> No sign off?

The second From: should be s-o-b, copy-paste mistake.

Rafael
