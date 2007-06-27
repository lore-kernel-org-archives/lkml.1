Return-Path: <linux-kernel-owner+w=401wt.eu-S1761883AbXF0Qyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761883AbXF0Qyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbXF0Qyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:54:32 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34758 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbXF0Qyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:54:31 -0400
Date: Wed, 27 Jun 2007 10:54:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matt Domsch <Matt_Domsch@dell.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: pci.h stubs
Message-ID: <20070627165429.GY22063@parisc-linux.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com> <20070627024505.GA30197@humbolt.us.dell.com> <20070627113048.GU22063@parisc-linux.org> <20070627145500.2e66fd49@the-village.bc.nu> <46829345.1000607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46829345.1000607@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 12:41:41PM -0400, H. Peter Anvin wrote:
> Note that EDD has no way of referencing anything but the zero domain 
> (which is presumably the one which is addressed by I/O ports CF8/CFC on 
> the BSP.)  So in this particular case I would say pci_get_bus_and_slot() 
> is fine.

Except that you're not guaranteed to get the bus that's in domain zero.
