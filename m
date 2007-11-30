Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbXK3IHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbXK3IHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbXK3IHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:07:04 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34577 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932291AbXK3IHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:07:02 -0500
To: neilb@suse.de
CC: a.p.zijlstra@chello.nl, fengguang.wu@gmail.com,
       linux-kernel@vger.kernel.org
In-reply-to: <18255.24276.519113.975347@notabene.brown> (message from Neil
	Brown on Fri, 30 Nov 2007 11:52:36 +1100)
Subject: Re: [patch 1/3] bdi patches
References: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu> <18255.24276.519113.975347@notabene.brown>
Message-Id: <E1Iy0tl-0003qA-2U@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 30 Nov 2007 09:06:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Provide a place in sysfs for the backing_dev_info object.
> > This allows us to see and set the various BDI specific variables.
> 
> You don't say what the place is, and I'm not quite familiar enough
> with sysfs internals to figure it out my self.  Help?

/sys/class/bdi  (which sometimes links into /sys/devices/virtual/bdi)

> And while I was looking I noticed that bdi_register (and bdi_init_fmt)
> takes a second argument 'parent', which is always NULL, and which is
> undocumented as to purpose.
> If no-one would ever add another call to bdi_register, why have the
> second arg, and if they might, how would they know what to put there?
> 
> Finally, the omission of NFS bothers me - and makes me wonder if the
> choice of name in sysfs is appropriate.
> 
> Would a program ever want to generate the name (in sysfs) for a
> particular bdi?  If so, how would it do it.

I'll let Peter answer these, when he gets back.

> It seems to me after a fairly quick look that a bdi is always
> associated with a device number.  For block devices the device number
> is obvious.  For NFS and FUSE, the device number is an anon device
> number allocated at mount time.
> Maybe the name of the bdi should be based on that number.  Then it
> would be possible to map directly from e.g. a file to the bdi that the
> file would be written to. 

Sounds like a good idea to me.

Miklos
