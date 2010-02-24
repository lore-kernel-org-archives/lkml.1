Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740Ab0BXUJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:09:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57995 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757442Ab0BXUJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:09:18 -0500
Date: Wed, 24 Feb 2010 15:09:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Testing for dirty buffers on a block device
In-Reply-To: <20100224190942.GG1025@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1002241503300.1253-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Jens Axboe wrote:

> > > But if you wanted, I guess the only way would be to lookup
> > > dirty/writeback pages on the bdev inode mapping. For that you'd need the
> > > bdev, not the gendisk or the queue though.
> > 
> > I can get the bdev from the gendisk by calling bdget_disk() with a 
> > partition number of 0, right?  What would the next step be?  Would this 
> > check for dirty pages associated with any of the partitions or would it 
> > only look at pages associated with the inode for the entire disk?
> 
> It would cover the entire bdev.

Okay, so once I've got the bdev, how do I look up the dirty/writeback 
pages on the inode mapping?

Alan Stern

