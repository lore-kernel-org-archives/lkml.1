Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbXFZWcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbXFZWcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbXFZWcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:32:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24793 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbXFZWcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:32:32 -0400
Date: Tue, 26 Jun 2007 15:33:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Torsten Duwe <duwe@lst.de>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: EDD build error
Message-Id: <20070626153336.e7156b7e.randy.dunlap@oracle.com>
In-Reply-To: <200706270016.44999.duwe@lst.de>
References: <20070626132622.3226261a.randy.dunlap@oracle.com>
	<200706270016.44999.duwe@lst.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 00:16:44 +0200 Torsten Duwe wrote:

> On Tuesday 26 June 2007, Randy Dunlap wrote:
> 
> > ERROR: "pci_get_bus_and_slot" [drivers/firmware/edd.ko] undefined!
> > make[1]: *** [__modpost] Error 1
> >
> > Should EDD depend on PCI or should some parts of edd.c be stubbed?
> 
> I'd suggest to simply stub it, as attached (untested, as my crap-Awarded BIOS
> only has 2.1). It may not be nice to pull in the PCI defs and then return NULL
> regardless, but should be safe in your case. Does that work?


>From original email:
(This is in 2.6.22-rc4-mm2 FWIW.)

so quilt+patch says:

Applying patch EDD.diff
patching file drivers/firmware/edd.c
Hunk #1 FAILED at 669.
1 out of 1 hunk FAILED -- rejects in file drivers/firmware/edd.c
Patch EDD.diff does not apply (enforce with -f)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
