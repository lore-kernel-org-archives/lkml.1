Return-Path: <linux-kernel-owner+w=401wt.eu-S1755695AbXLTDea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbXLTDea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 22:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbXLTDeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 22:34:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1343 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753688AbXLTDeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 22:34:21 -0500
Date: Wed, 19 Dec 2007 22:34:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <mdharm-usb@one-eyed-alien.net>, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: 2.6.24-rc5-mm1
In-Reply-To: <a8e1da0712191643p74a88c35u45681b11b0492474@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0712192226220.15674-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note carefully.  This:

> > > 2. on 2.6.24-rc5 kernel reports only the part 1, after try mount the
> > > disk it reports the part 2 and mount the partition as rw

contradicts this:

> > > 3. on 2.6.24-rc5 kernel reports only the part 1, after try mount the
> > > disk it just mount the partition as ro with nothing more messages.

So which is correct?

> Hi, Alan
> 
> I'm sure about my post.

But your post contradicts itself.  It can't be correct.

> I'm not so famillar with usb.
> It looks weird.  Seems that my device will be firstly recoganized as a
> mp3 player and then a usb storage, so the system will report part 1 &
> part 2 under previous  kernels.

I think those "part 2" messages aren't caused by the kernel at all, but
instead by some program running on your computer.  You could try
booting into single-user mode and see if the behavior changes.

Also there's no question -- the device does behave strangely.  It
shouldn't change the write-protect setting all by itself.

Alan Stern

