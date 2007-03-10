Return-Path: <linux-kernel-owner+w=401wt.eu-S1161158AbXCJPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158AbXCJPhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161139AbXCJPhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:37:24 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44201 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161041AbXCJPhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:37:23 -0500
Date: Sat, 10 Mar 2007 16:40:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: kristen.c.accardi@intel.com, len.brown@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: libata-acpi: allow _GTF on SATA, but disable on PATA for now
Message-ID: <20070310164059.4ba68bcc@lxorguk.ukuu.org.uk>
In-Reply-To: <45F296B9.7000005@garzik.org>
References: <200703100559.l2A5x6kP017578@hera.kernel.org>
	<45F296B9.7000005@garzik.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan has been actively working on PATA ACPI, and we have been debugging 
> ACPI issues as well.  PLEASE coordinate with the maintainer, when 
> touching code outside of drivers/acpi!

ap->cbl is not a reliable way to tell SATA from PATA at the moment. We
need to fix the real crashes too - right now no non PCI controller
actually works at all (crash on boot) because of the ACPI crap.

Please drop this patch as it will cause regressions on systems that do
not need the extra methods. Instead merge the one that fixe the non PCI
crashes and we might get further.

> AFAICS this patch went in with zero appearance on LKML or another 
> related list, until submission.  This is /not/ how we do Linux development.

Agreed.

NAK the patch likewise.

Alan
