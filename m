Return-Path: <linux-kernel-owner+w=401wt.eu-S934142AbYBGAjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934142AbYBGAjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765025AbYBGAJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:09:42 -0500
Received: from mail.suse.de ([195.135.220.2]:48123 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765254AbYBGAJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:09:40 -0500
Date: Wed, 6 Feb 2008 16:07:45 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080207000745.GB16389@suse.de>
References: <20080206.152639.35541094.davem@davemloft.net> <20080206233117.GA28931@suse.de> <20080206155749.ce1fcd25.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206155749.ce1fcd25.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 03:57:49PM -0800, Andrew Morton wrote:
> > How is it working for anyone else then?  sparc64 isn't doing anything
> > "odd" with it's block devices, is it?
> > 
> > > I'm pretty sure the following changeset is to blame:
> > > 
> > > commit edfaa7c36574f1bf09c65ad602412db9da5f96bf
> > > Author: Kay Sievers <kay.sievers@vrfy.org>
> > > Date:   Mon May 21 22:08:01 2007 +0200
> > > 
> > >     Driver core: convert block from raw kobjects to core devices
> > >     
> > >     This moves the block devices to /sys/class/block. It will create a
> > >     flat list of all block devices, with the disks and partitions in one
> > >     directory. For compatibility /sys/block is created and contains symlinks
> > >     to the disks.
> > 
> > So I'm guessing if you revert this it works?
> 
> Going offtopic here...
> 
> The patch was committed to mainline last week and it has a git timestamp
> from eight months ago.  When you received the original email from Kay.
> 
> But the patch changed in that time period.  This doesn't seem right?

The patch did change over time, but not that much, minor bugfixes for
it.  I didn't think to update the original date in the quilt file,
sorry.  It was in -mm for quite a while, so I thought it got a good
enough testing period.

I'll try to remember to update the timestamp on patches that get
updated, it's a pretty rare thing for my patchflow, shouldn't be hard to
remember.

thanks,

greg k-h
