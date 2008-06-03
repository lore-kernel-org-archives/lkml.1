Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYFCKiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYFCKiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYFCKiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:38:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60981 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbYFCKiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:38:08 -0400
To: jesper@krogh.cc
CC: raven@themaw.net, viro@ZenIV.linux.org.uk, jesper@krogh.cc,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Tue, 03 Jun 2008 12:13:54 +0200)
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
    <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
    <20080603095713.GR28946@ZenIV.linux.org.uk> <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
Message-Id: <E1K3Ttv-0005ji-Cx@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 03 Jun 2008 12:37:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > On Tue, Jun 03, 2008 at 11:49:32AM +0200, Jesper Krogh wrote:
> > >
> > >
> > >> I reported it to the NFS-guys on a .22 kernel, and was directed to the
> > >> fsdevel list(CC'ed again) back then. Now the problem is reproduced on
> > >> .26-rc4
> > >>
> > >
> > > Lovely...  Do you have the full oops trace, with the actual code
> > > dump? --
> > 
> > This is all I got from the logs. I'll try go get more from the serial
> 
> Probably the same as this one:
> 
> http://www.kerneloops.org/raw.php?rawid=12419&msgid=
> 
> Looks like a negative inode in S_ISDIR(mnt->mnt_root->d_inode->i_mode),
> which would be due to NFS not properly filling in its root dentry?

On second thought it's S_ISDIR(path->dentry->d_inode->i_mode), which
means it's an autofs thing.

CC-ing Ian.

Miklos
