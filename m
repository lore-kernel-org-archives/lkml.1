Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYG2Sua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYG2Sua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753730AbYG2SuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:50:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43330 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYG2SuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:50:19 -0400
Date: Tue, 29 Jul 2008 12:50:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>,
       linux-kernel@vger.kernel.org, Martin Petersen <mkp@mkp.net>,
       Jeff Garzik <jeff@garzik.org>, Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: tools support for non-512 byte sector sizes
Message-ID: <20080729185002.GD24924@parisc-linux.org>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <20080729184243.GC24924@parisc-linux.org> <1217357078.6103.51.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217357078.6103.51.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 01:44:38PM -0500, James Bottomley wrote:
> On Tue, 2008-07-29 at 12:42 -0600, Matthew Wilcox wrote:
> > On Tue, Jul 29, 2008 at 01:37:25PM -0500, James Bottomley wrote:
> > > scsi_debug does exactly the same thing, so it reports anything you tell
> > > it (Martin Petersen actually added this so he could test with 4k
> > > sectors).
> > > 
> > > The problem, which ata_ram also suffers, is that the tools we most need
> > > to test are the ones for manipulating non volatile characteristics (like
> > > partition tables).  We'd really like the disk contents to survive reboot
> > > for this ...
> > 
> > Ummm... _reboot_, or _module unload/reload_?  I could certainly include
> > an option to populate the ramdisc from a file.  Is the ioctl to re-read
> > the partition table not enough?
> 
> reboot ... we'd like to take the tools through shutdown restart testing
> to make sure they're all working ... of course, then there's the
> bios ...

It's not up to us to fix the BIOS.

Since the vast majority of users use a distro, and the vast majority of
distros use a fully modular kernel, wouldn't initialising the contents
of ata-ram from the initrd/initramfs solve the problem?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
