Return-Path: <linux-kernel-owner+w=401wt.eu-S933621AbXGQTPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621AbXGQTPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbXGQTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:15:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47207 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbXGQTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:15:30 -0400
Date: Tue, 17 Jul 2007 20:15:18 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gdth: remove redundant PCI stuff
Message-ID: <20070717191518.GA8955@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20070717092517.GA28201@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717092517.GA28201@havoc.gtf.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 05:25:17AM -0400, Jeff Garzik wrote:
> This patch
> 
> * removes struct members that duplicate pci_dev members
> * replaces ha->stype usage with ha->pdev->device usage where feasible

These two bits look nice.

> * removes PCI IDs that are already in include/linux/pci_ids.h

note sure about this one.  The list of partially unused pci ids in the
header is one of the few guidelines what pci ids are actually supported
by this driver.

And btw, please Cc Achim on your patches, he still maintains the driver
although it sometimes seems hard to actually get your patches into his
inbox.

