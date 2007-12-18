Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbXLRDEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbXLRDEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXLRDD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:03:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33873
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbXLRDDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:03:55 -0500
Date: Mon, 17 Dec 2007 19:03:54 -0800 (PST)
Message-Id: <20071217.190354.200414687.davem@davemloft.net>
To: crn@netunix.com
Cc: stefanr@s5r6.in-berlin.de, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, gregkh@suse.de, krh@bitplanet.net,
       linux1394-devel@lists.sourceforge.net
Subject: Re: No dma_sync_* during pci_probe? (Sparc, post 2.6.22 regression)
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.60.0712180255450.10484@mailgate.netunix.com>
References: <47112797.7060003@s5r6.in-berlin.de>
	<47670BDF.80409@s5r6.in-berlin.de>
	<Pine.LNX.4.60.0712180255450.10484@mailgate.netunix.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Newport <crn@netunix.com>
Date: Tue, 18 Dec 2007 02:58:29 +0000 (GMT)

> On Tue, 18 Dec 2007, Stefan Richter wrote:
> 
> > It's a 100% reproducible oops on Sparc (with FireWire controller) for
> > 2.6.23 and 2.6.24 kernels, but not 2.6.22.  The reporter confirmed that
> > the bug also happens
> 
> How do you achieve a sparc system with firewire ?
> AFAIK there is no SBUS firewire card.

He means sparc64, which have PCI firewire onboard many
systems.
