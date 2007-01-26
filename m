Return-Path: <linux-kernel-owner+w=401wt.eu-S1030847AbXAZK0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030847AbXAZK0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 05:26:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030855AbXAZK0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 05:26:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60308 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030847AbXAZK0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 05:26:03 -0500
Date: Fri, 26 Jan 2007 10:37:20 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
Message-ID: <20070126103720.1d5b6ac0@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0701251751380.25027@woody.linux-foundation.org>
References: <20070125150905.652f9ce2@localhost.localdomain>
	<1169741658.3593.98.camel@shinybook.infradead.org>
	<20070125172739.0c990a9a@localhost.localdomain>
	<Pine.LNX.4.64.0701250940220.25027@woody.linux-foundation.org>
	<1169770985.3593.146.camel@shinybook.infradead.org>
	<Pine.LNX.4.64.0701251703570.25027@woody.linux-foundation.org>
	<45B95D3A.10108@pobox.com>
	<Pine.LNX.4.64.0701251751380.25027@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, many ISA-only drivers actually have hardcoded PIO numbers (eg 
> "0x1f0").

Bad example - 0x1F0 is one of those that leaked into the PCI world as
well 8)
