Return-Path: <linux-kernel-owner+w=401wt.eu-S1423708AbXEEAmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423708AbXEEAmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 20:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423710AbXEEAmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 20:42:31 -0400
Received: from thunk.org ([69.25.196.29]:49122 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423708AbXEEAmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 20:42:31 -0400
Date: Fri, 4 May 2007 14:49:43 -0400
From: Theodore Tso <tytso@mit.edu>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mkfs.ext2 triggerd RAM corruption
Message-ID: <20070504184943.GC25339@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bernd Schubert <bs@q-leap.de>, linux-kernel@vger.kernel.org
References: <200705041659.51675.bs@q-leap.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705041659.51675.bs@q-leap.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 04:59:51PM +0200, Bernd Schubert wrote:
> 
> I'm presently rather puzzled, if this is really a kernel bug, its a big bug. 
> 
> Summary: The system ramdisk (initrd) gets corrupted while running
> mkfs.ext2 on a local sata disk partition.

What distribution are you using?  What's the hardware configuration,
including amount of memory?  What is the partition table look
like for /dev/sda?  What filesystems are mounted?  If you have any
soft RAID partitions, are any of them using part of /dev/sda?  What
swap partitions are you using?  And do any of the swap partitions
overlap with /dev/sda?  :-)

						- Ted
