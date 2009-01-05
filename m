Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZAEXJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZAEXJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZAEXJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:09:48 -0500
Received: from thunk.org ([69.25.196.29]:46533 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZAEXJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:09:47 -0500
Date: Mon, 5 Jan 2009 18:09:29 -0500
From: Theodore Tso <tytso@mit.edu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Pavel Machek <pavel@suse.cz>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090105230929.GA14500@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Pavel Machek <pavel@suse.cz>, Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org
References: <fa.P4z5CJpM0xT37PWJuOuCHDkO76o@ifi.uio.no> <fa.26o5IHCAC3TQdXupl62CLYwQ+Wk@ifi.uio.no> <fa.GBkQuKdRj+YRVczlNLFhGvaw3WY@ifi.uio.no> <fa.rCyCghh/+staAmYi/+gwYvefIS0@ifi.uio.no> <fa.c5j7jAMUnJPvgI9Oj/VczSDNakE@ifi.uio.no> <fa.377DMq2lPMyaHxadPnApFSJFoCg@ifi.uio.no> <49626F4C.80600@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49626F4C.80600@yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 08:36:28PM +0000, Sitsofe Wheeler wrote:
> Theodore Tso wrote:
>> Don't forget non-cheasy mounting options so an accidental brush
>> against the side of the unit doesn't cause the hard drive to become
>> disconnected from system and suffer a power drop.  I guess that gets
>> filed under "Brute force" as well.  :-)
>
> Are you thinking of sync? 

No, I was talking about physical mounting issues; as I said earlier in
the e-mail message you replied to (you must not have read my e-mail
carefully), Pavel ran into a problem where the SD card protruded
slightly from the laptop case, and it would easily (via physical
contact) get loosed from its connector so that it would become
disconnected from the laptop, causing it to lose power, sometimes
while it was writing, leading to filesystem corruptions.

> If so I have experience of this not helping  
> with ext3 on an 8Gbyte SD card in an EeePC 900. Sooner or later a bunch  
> of zeros overwrites the early part of the partition and an fsck tears  
> the FS apart. This seems to happen quickly if you are booting your root  
> from the SD card (no swap though). A FAT32 partition seems to be  
> unperturbed so far (but it's not being used the same way as the ext3  
> partition).

A quick google search found some interesting posts on the subject:

  http://forum.eeeuser.com/viewtopic.php?id=37174
  http://lists.alioth.debian.org/pipermail/debian-eeepc-devel/2008-August/000837.html
  http://www.spinics.net/lists/linux-scsi/msg28197.html
  http://kerneltrap.org/mailarchive/git-commits-head/2008/8/6/2832894

							- Ted
