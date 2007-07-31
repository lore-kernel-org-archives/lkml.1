Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbXGaIxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbXGaIxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXGaIw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:52:59 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:54685 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbXGaIw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:52:58 -0400
To: chuck.lever@oracle.com
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       kzak@redhat.com, sfrench@samba.org, trond.myklebust@fys.uio.no,
       mark.fasheh@oracle.com, kurt.hackel@oracle.com
In-reply-to: <46AE01C2.3000008@oracle.com> (message from Chuck Lever on Mon,
	30 Jul 2007 11:20:34 -0400)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu> <46AA51CA.7030105@oracle.com> <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu> <46AE01C2.3000008@oracle.com>
Message-Id: <E1IFnSa-0002BL-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 31 Jul 2007 10:52:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> After a successful mount, the NFS mount command tucks some options into 
> /etc/mtab that reflect which mountd was used for the mount, and what 
> protocol version and port was used for the mount request.  Those options 
> are not passed to the kernel, and do not appear in /proc/mounts today. 
> See nfs(5)'s discussion of the mountport, mounthost, mountprog, and 
> mountvers options.
> 
> However, the trend for NFS is to push mount option parsing into the 
> kernel.  Thus all options will be passed to the kernel, and at that 
> point it should be able to reflect the mount* options in /proc/mounts. 
> But it doesn't do that quite yet.

Trond, do you have a roadmap for this?

> I'm wondering if there are other such cases in other file systems.

Anything that has /sbin/mount.XXX could be doing this.  According to
Karel, those are nfs, cifs and ocfs2.

Miklos
