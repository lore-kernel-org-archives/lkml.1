Return-Path: <linux-kernel-owner+w=401wt.eu-S1759206AbXF0LbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206AbXF0LbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXF0Lav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:30:51 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54410 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbXF0Lau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:30:50 -0400
Date: Wed, 27 Jun 2007 05:30:48 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs (was: EDD build error)
Message-ID: <20070627113048.GU22063@parisc-linux.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com> <20070627024505.GA30197@humbolt.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627024505.GA30197@humbolt.us.dell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 09:45:05PM -0500, Matt Domsch wrote:
> On Tue, Jun 26, 2007 at 01:26:22PM -0700, Randy Dunlap wrote:
> > ERROR: "pci_get_bus_and_slot" [drivers/firmware/edd.ko] undefined!
> 
> It should be stubbed, in include/linux/pci.h where all the other PCI
> functions are stubbed for the !CONFIG_PCI case.

pci_get_bus_and_slot() shouldn't be used because it fails to work on
systems with multiple domains.  pci_get_slot() avoids this problem (and
is much faster too).
