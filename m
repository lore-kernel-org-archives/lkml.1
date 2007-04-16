Return-Path: <linux-kernel-owner+w=401wt.eu-S1030937AbXDPULL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030937AbXDPULL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030942AbXDPULL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:11:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51376 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030937AbXDPULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:11:08 -0400
Date: Mon, 16 Apr 2007 12:58:10 -0700
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 02/10] allow unprivileged umount
Message-ID: <20070416195810.GB16255@kroah.com>
References: <20070416110308.739051445@szeredi.hu> <20070416110403.068601478@szeredi.hu> <m1vefwjehk.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vefwjehk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 01:39:19PM -0600, Eric W. Biederman wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > From: Miklos Szeredi <mszeredi@suse.cz>
> >
> > The owner doesn't need sysadmin capabilities to call umount().
> >
> > Similar behavior as umount(8) on mounts having "user=UID" option in
> > /etc/mtab.  The difference is that umount also checks /etc/fstab,
> > presumably to exclude another mount on the same mountpoint.
> >
> 
> bool in the kernel?

It's there already...

> int would be much more recognizable as this is not C++
> 
> Or do you have place to convert the rest of the kernel that is using
> int to return a true/false value to bool?

It's already underway:
	$ git log | grep bool | wc -l
	123

