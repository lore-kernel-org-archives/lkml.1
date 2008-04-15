Return-Path: <linux-kernel-owner+w=401wt.eu-S1764650AbYDOOUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764650AbYDOOUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbYDOOUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:20:11 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52492 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510AbYDOOUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:20:08 -0400
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <htejun@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Greg KH <gregkh@suse.de>,
       Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20080415001828.b0c9ed64.akpm@linux-foundation.org>
References: <47E875AD.1000901@rtr.ca> <47E88A13.70808@zytor.com>
	 <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com>
	 <47E9383F.3050908@rtr.ca> <20080325192515.GA24234@suse.de>
	 <47E99A02.7040903@rtr.ca> <47E99EBE.7010708@gmail.com>
	 <3ae72650803271229h6e188de1t81ccfb64e5d3a214@mail.gmail.com>
	 <47EBF7D0.6000901@zytor.com>
	 <e9c3a7c20804111625w68b21b24p6fbd85864713d62f@mail.gmail.com>
	 <20080415001828.b0c9ed64.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 09:20:02 -0500
Message-Id: <1208269202.3131.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 00:18 -0700, Andrew Morton wrote:
> On Fri, 11 Apr 2008 16:25:32 -0700 "Dan Williams" <dan.j.williams@intel.com> wrote:
> 
> > >  It doesn't really seem to be to belong under class at all.  I would suggest
> > > /sys/dev/char/ and /sys/dev/block/, for char and block respectively.
> > >
> > 
> > This thread fizzled out without a patch... here goes:
> > 
> > ...
> >
> > sysfs: add /sys/dev/{char,block} to lookup sysfs path by major:minor
> 
> Crickets are chirping and I can't remember what the conclusion to all this
> was.  In fact the thread was more than ten-deep so I probably fell asleep.
> 
> I queued it up so that others cannot do the same ;)

The expressed preference was simply to expand the ioctl (or add a new
one that got the required information without having to go through the
old HDIOGETGEO path to extract the value from a fictitious geometry).

Greg was a bit sceptical of the value of the above proposal ...

James


