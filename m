Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbXGNIPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbXGNIPk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 04:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXGNIP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 04:15:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:54681 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbXGNIP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 04:15:27 -0400
Date: Sat, 14 Jul 2007 04:15:26 -0400
From: Jeff Garzik <jeff@garzik.org>
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] libata: add taskfile protocol ->proto_mask info member
Message-ID: <20070714081526.GA26878@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These patches add proto_mask alongside pio_mask, mwdma_mask, and
udma_mask.  This is a more uniform way to export which features host
controllers support (DMA? NCQ? ATAPI? ATAPI DMA?), rather than creating
a new ATA_FLAG_xxx for each.

This also opens the door to useful things like combining "if
protocol==foo || protocol==bar" tests into a single mask, or masking
between host and device to determine common protocols.

Suggestions for improvement welcome, this is just the first cut.  Stored
on libata-dev.git#pmask for now.

	Jeff




