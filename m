Return-Path: <linux-kernel-owner+w=401wt.eu-S1761341AbXGEMpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341AbXGEMpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbXGEMp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:45:28 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:47463 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbXGEMp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:45:28 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, stern@rowland.harvard.edu, oliver@neukum.org,
       paulus@samba.org, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <200707051439.37737.rjw@sisk.pl>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
References: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org> <200707042336.58466.rjw@sisk.pl> <E1I6Mq2-0008WB-00@dorka.pomaz.szeredi.hu> <200707051439.37737.rjw@sisk.pl>
Message-Id: <E1I6QcZ-0000ex-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 14:39:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > PF_FREEZER_SKIP flag.  Perhaps we can do similar thing with FUSE.
> > 
> > It cannot be just worked around in fuse, as a task might be sleeping
> > on a number of VFS mutexes as well (i_mutex, s_vfs_rename_mutex, etc).
> > It would be a gigantic hack, possible at all.
> 
> Well, obviously FUSE and the freezer don't play well together, but
> that's FUSE who's late in the game (the freezer was here
> before). ;-)

Umm, and CODA which is _very_ similar to fuse was there long before
fuse or the freezer ;)

> If you give me some time, I'll see what can be done.

I give you all the time in the world.  I'd also be willing to help
with drivers for which I have the hardware.

Miklos
