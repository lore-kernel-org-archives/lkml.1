Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYKUQa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYKUQa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756768AbYKUQ2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:28:46 -0500
Received: from kroah.org ([198.145.64.141]:41883 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757460AbYKUQ2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:28:44 -0500
Date: Fri, 21 Nov 2008 08:21:38 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de, kkeil@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_PCI_LEGACY removal
Message-ID: <20081121162138.GC13564@kroah.com>
References: <20081121181426.9f5efa36.sfr@canb.auug.org.au> <20081121110819.GA5707@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121110819.GA5707@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 04:08:19AM -0700, Matthew Wilcox wrote:
> > drivers/pci/hotplug/cpqphp_pci.c
> 
> The cpqphp driver is basically unmaintained.  Last time I spoke to Greg
> about it (which was probably three years ago) he said it wasn't possible
> to find a machine which had one of these any more.
> 
> I suspect the driver should simply be deleted, but if anyone steps up
> and claims to have one of these to test the resulting patch, I'm willing
> to remove pci_find_slot() from it.

I say mark it CONFIG_BROKEN for now.

thanks,

greg k-h
