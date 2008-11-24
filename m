Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbYKXDG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbYKXDG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 22:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYKXDGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 22:06:49 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52742 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbYKXDGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 22:06:47 -0500
Date: Sun, 23 Nov 2008 22:01:11 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Tejun Heo <teheo@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com
Subject: Re: about TRIM/DISCARD support and barriers
Message-ID: <20081124030111.GC2163@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>, Tejun Heo <teheo@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	IDE/ATA development list <linux-ide@vger.kernel.org>,
	Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
	chris.mason@oracle.com
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de> <20081123123514.GI5707@parisc-linux.org> <1227447584.4901.405.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227447584.4901.405.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 01:39:44PM +0000, David Woodhouse wrote:
> On Sun, 2008-11-23 at 05:35 -0700, Matthew Wilcox wrote:
> > The current VFAT filesystem implements DISCARD. 
> 
> As does btrfs. I think I posted ext2 patches a little while ago too? Or
> someone else did. Did they get merged?

Looks like they didn't get merged.  I thought akpm was going to merge
them.  Ext4 has discard support though.  It doesn't port easily to
ext3 since it ext4 has a new block allocator.

					- Ted
