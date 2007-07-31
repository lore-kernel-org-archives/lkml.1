Return-Path: <linux-kernel-owner+w=401wt.eu-S1763029AbXGaUXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763029AbXGaUXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbXGaUXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:23:12 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:59434 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758924AbXGaUXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:23:10 -0400
To: chuck.lever@oracle.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kzak@redhat.com, sfrench@samba.org,
       trond.myklebust@fys.uio.no, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com
In-reply-to: <46AF450D.5020106@oracle.com> (message from Chuck Lever on Tue,
	31 Jul 2007 10:19:57 -0400)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu> <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu> <46AE01C2.3000008@oracle.com> <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu> <46AF450D.5020106@oracle.com>
Message-Id: <E1IFyEK-00042c-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 31 Jul 2007 22:22:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> After a successful mount, the NFS mount command tucks some options into 
> >> /etc/mtab that reflect which mountd was used for the mount, and what 
> >> protocol version and port was used for the mount request.  Those options 
> >> are not passed to the kernel, and do not appear in /proc/mounts today. 
> >> See nfs(5)'s discussion of the mountport, mounthost, mountprog, and 
> >> mountvers options.
> >>
> >> However, the trend for NFS is to push mount option parsing into the 
> >> kernel.  Thus all options will be passed to the kernel, and at that 
> >> point it should be able to reflect the mount* options in /proc/mounts. 
> >> But it doesn't do that quite yet.
> > 
> > Trond, do you have a roadmap for this?
> 
> Well I'm actually doing the coding, and Trond is playing more of an 
> architectural role.

OK, what your estimage for this then?

It would be nice to have all this stuff in 2.6.24, which doesn't leave
a lot of time.

But if it's just those four options you mentioned, it should be
managable.  I do not think there needs to be some generic code to
hande userspace-only options, it would be perfectly fine just to
parse, store and show them like all the other options.

Miklos
