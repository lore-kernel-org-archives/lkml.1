Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbYIXGrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbYIXGrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 02:47:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYIXGrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 02:47:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56624
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbYIXGrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 02:47:17 -0400
Date: Tue, 23 Sep 2008 23:47:05 -0700 (PDT)
Message-Id: <20080923.234705.261909334.davem@davemloft.net>
To: grundler@parisc-linux.org
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Notes from LPC PCI/MSI BoF session
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080924055116.GA3101@colo.lackof.org>
References: <200809221229.18501.jbarnes@virtuousgeek.org>
	<20080924055116.GA3101@colo.lackof.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Grundler <grundler@parisc-linux.org>
Date: Tue, 23 Sep 2008 23:51:16 -0600

> Dave Miller (and others) have clearly stated they don't want to see
> CPU affinity handled in the device drivers and want irqbalanced
> to handle interrupt distribution. The problem with this is irqbalanced
> needs to know how each device driver is binding multiple MSI to it's queues.
> Some devices could prefer several MSI go to the same processor and
> others want each MSI bound to a different "node" (NUMA).
> 
> Without any additional API, this means the device driver has to
> update irqbalanced for each device it supports. We thought pci_ids.h
> was a PITA...that would be trivial compared to maintaining this.

We just need a consistent naming scheme for the IRQs to disseminate
this information to irqbalanced, then there is one change to irqbalanced
rather than one for each and every driver as you seem to suggest.

Anything that's complicated and takes more than a paragraph or two
to describe is not what we want.
