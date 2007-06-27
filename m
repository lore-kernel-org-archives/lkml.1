Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbXF0RTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbXF0RTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbXF0RTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:19:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55145 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751600AbXF0RTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:19:32 -0400
Date: Wed, 27 Jun 2007 18:25:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs
Message-ID: <20070627182518.50423241@the-village.bc.nu>
In-Reply-To: <20070627165429.GY22063@parisc-linux.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com>
	<20070627024505.GA30197@humbolt.us.dell.com>
	<20070627113048.GU22063@parisc-linux.org>
	<20070627145500.2e66fd49@the-village.bc.nu>
	<46829345.1000607@zytor.com>
	<20070627165429.GY22063@parisc-linux.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 10:54:30 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jun 27, 2007 at 12:41:41PM -0400, H. Peter Anvin wrote:
> > Note that EDD has no way of referencing anything but the zero domain 
> > (which is presumably the one which is addressed by I/O ports CF8/CFC on 
> > the BSP.)  So in this particular case I would say pci_get_bus_and_slot() 
> > is fine.
> 
> Except that you're not guaranteed to get the bus that's in domain zero.

Which is trivial to fix
