Return-Path: <linux-kernel-owner+w=401wt.eu-S1751646AbZIYQxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbZIYQxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 12:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbZIYQxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 12:53:25 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58946 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZIYQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 12:53:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Fri, 25 Sep 2009 10:53:16 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] vfs: new O_NODE open flag
In-reply-to: <20090925123747.GA31228@gallifrey>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruen@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20090925165316.GT10562@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu>
 <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
 <20090925123747.GA31228@gallifrey>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 25, 2009  13:37 +0100, Dr. David Alan Gilbert wrote:
> * Miklos Szeredi (miklos@szeredi.hu) wrote:
> > On Fri, 25 Sep 2009, Andreas Gruenbacher wrote:
> > > On Thursday, 24 September 2009 16:51:58 Miklos Szeredi wrote:
> > > > This patch adds a new open flag, O_NODE.  This flag means: open just
> > > > the filesystem node instead of the object referenced by the node.
> > > 
> > > What is the intended use for O_NODE?
> > 
> > It lets userspace file descriptors reference a inode without actually
> > "dereferencing" it to get the underlying object.  This allows for a
> > couple of new things:
> > 
> >  - opening a special file (device/socket/fifo) without side effects
> > 
> >  - opening a symlink
> > 
> >  - opening any type of file without any permission is also possible
> >    (of course the resuling file descriptor may not be read or written)
> > 
> > The above allows fstat(), fchmod(), ioctl(), etc to be used for files
> > previously not possible.
> 
> Given an fd opened in this way is it possible to reopen it normally and
> be guarenteed to get the same object?

That was something I'd be interested in as well.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

