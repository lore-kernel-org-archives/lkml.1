Return-Path: <linux-kernel-owner+w=401wt.eu-S1758441AbYKVOmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441AbYKVOmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 09:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbYKVOmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 09:42:07 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29787 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbYKVOmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 09:42:05 -0500
Date: Sat, 22 Nov 2008 07:41:59 -0700
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, greg@kroah.com,
       linux-pci@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       kkeil@suse.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CONFIG_PCI_LEGACY removal
Message-ID: <20081122144159.GH25709@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	LKML <linux-kernel@vger.kernel.org>, greg@kroah.com,
	linux-pci@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
	kkeil@suse.de, Andrew Morton <akpm@linux-foundation.org>
References: <20081121181426.9f5efa36.sfr@canb.auug.org.au> <20081121110819.GA5707@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121110819.GA5707@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Fri, Nov 21, 2008 at 06:14:26PM +1100, Stephen Rothwell wrote:
> 
> I think the plan is to delete all these drivers once the new ISDN layer
> is a bit more battle-hardened.
> 
> > User of pci_find_slot():
> > 
> > drivers/pci/hotplug/cpqphp_pci.c
> 
> The cpqphp driver is basically unmaintained.  Last time I spoke to Greg
> about it (which was probably three years ago) he said it wasn't possible
> to find a machine which had one of these any more.

I've managed to track some down.

> I suspect the driver should simply be deleted, but if anyone steps up
> and claims to have one of these to test the resulting patch, I'm willing
> to remove pci_find_slot() from it.

Converting cpqphp to use the modern pci_get_slot() API has been
on my TODO list for a while. It was languishing because I
couldn't find hardware nor time.

I've got hardware now. Just need to free up a few cycles. :-/

But if it's not worth it, I'm fine with marking as CONFIG_BROKEN
and scheduling for eventual deletion.

/ac

