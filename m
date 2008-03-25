Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYCYPeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYCYPeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYCYPeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:34:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56037 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbYCYPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:34:24 -0400
Date: Tue, 25 Mar 2008 09:34:23 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ric Wheeler <ric@emc.com>
Cc: Mark Lord <lkml@rtr.ca>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH l <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Message-ID: <20080325153423.GD16721@parisc-linux.org>
References: <47E875AD.1000901@rtr.ca> <alpine.LFD.1.00.0803242254020.2775@woody.linux-foundation.org> <47E8FF58.8050209@rtr.ca> <47E90CDA.600@emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E90CDA.600@emc.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 10:31:54AM -0400, Ric Wheeler wrote:
> I think that there are many embedded applications (lots of them linux based)
> which have large amounts of storage behind low power, low cost 32 bit CPU's.
> 
> Think of the home/small office NAS boxes that you can get from bestbuy or 
> other big box stores. Those devices today have 4 S-ATA drives (each of 
> which can be 1TB in size).
> 
> Also, if you have a very low end box, it can still access really large 
> storage
> over iSCSI or a SAN which will present as a local, large device.

Don't those devices run into trouble with fsck?  The amount of memory
you need to fsck a device is obviously going to depend on the filesystem,
but it has to grow with device size, and I'm not sure that 4GB is enough
virtual address space to fsck 2TB.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
