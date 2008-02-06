Return-Path: <linux-kernel-owner+w=401wt.eu-S934373AbYBGAeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373AbYBGAeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764603AbYBGAAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:00:51 -0500
Received: from ns1.suse.de ([195.135.220.2]:46828 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764563AbYBGAAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:00:50 -0500
Date: Wed, 6 Feb 2008 15:59:02 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080206235902.GA15719@suse.de>
References: <20080206.152639.35541094.davem@davemloft.net> <20080206233117.GA28931@suse.de> <20080206.153714.133821225.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.153714.133821225.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 03:37:14PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Wed, 6 Feb 2008 15:31:17 -0800
> 
> > On Wed, Feb 06, 2008 at 03:26:39PM -0800, David Miller wrote:
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
> Unfortunately that's not so simple to test because afterwards there
> are changesets where all the files under block/ got renamed and as
> such I can't just revert that single patch from the tip.

Understood :(

but since you've bisected it down to this, that's a pretty big
suggestion that this is the problem.

What block drivers are you using for sparc?  Scsi?  Or something else?
What could make sparc64 different from x86 in regards to block device
structure, odd...

thanks,

greg k-h
