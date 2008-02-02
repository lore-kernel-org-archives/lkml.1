Return-Path: <linux-kernel-owner+w=401wt.eu-S1764084AbYBBSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764084AbYBBSqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 13:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYBBSqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 13:46:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbYBBSqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 13:46:24 -0500
Date: Sat, 2 Feb 2008 10:44:41 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [patch] pci: pci_enable_device_bars() fix (was: [GIT PATCH]
	PCI patches for 2.6.24)
Message-ID: <20080202184441.GA12301@suse.de>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202111322.GA30767@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 12:13:22PM +0100, Ingo Molnar wrote:
> 
> * Greg KH <gregkh@suse.de> wrote:
> 
> >       PCI: Remove users of pci_enable_device_bars()
> >       PCI: Remove pci_enable_device_bars()
> 
> simple allyesconfig testing found a build failure due to last night's 
> PCI merge, on 32-bit x86:
> 
>  drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_pci_probe_one':
>  drivers/scsi/lpfc/lpfc_init.c:1897: error: implicit declaration of function 'pci_enable_device_bars'
> 
> fix attached.
> 
> ( This call has been introduced upstream 3 weeks ago by commit 
>   8a4df120b07, but the PCI tree has apparently not been fully re-tested
>   with Linus-latest since that point. )

Wait, my testing caught this.  I made the change to the patch myself,
adding the needed conversion to my tree, it's here, on my disk!

Oh crap, I never checked it in.

/me goes off to sulk in shame.

Very sorry about this, totally my fault, I knew this needed to be fixed,
fixed it, but it didn't propogate to the tree to send to Linus.

I suck.  I need a vacation and an empty inbox.

I'll be sending fixup patches for this and other merge messes in a few
hours, once the coffee has kicked in...

greg k-h
