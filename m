Return-Path: <linux-kernel-owner+w=401wt.eu-S1751179AbZHQEam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbZHQEam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 00:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbZHQEal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 00:30:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:55910 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZHQEal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 00:30:41 -0400
Date: Sun, 16 Aug 2009 21:29:14 -0700
From: Greg KH <gregkh@suse.de>
To: Willy Tarreau <w@1wt.eu>
Cc: Thomas Backlund <tmb@mandriva.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.30
Message-ID: <20090817042914.GA20814@suse.de>
References: <20090816213523.GC7015@kroah.com>
 <4A8891AC.5090606@mandriva.org>
 <20090817042133.GB11624@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090817042133.GB11624@1wt.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 06:21:33AM +0200, Willy Tarreau wrote:
> On Mon, Aug 17, 2009 at 02:09:32AM +0300, Thomas Backlund wrote:
> > Greg KH skrev:
> > >I'm announcing the release of the 2.6.27.30 kernel.  All users of the
> > >2.6.27 kernel series are very strongly encouraged to upgrade.
> > >
> > >I'll also be replying to this message with a copy of the patch between
> > >2.6.27.29 and 2.6.27.30
> > >
> > >The updated 2.6.27.y git tree can be found at:
> > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.27.y.git
> > >and can be browsed at the normal kernel.org git web browser:
> > >        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=summary
> > >
> > >thanks,
> > >
> > >greg k-h
> > >
> > 
> > This is broken on x86_64
> > 
> > config attached....
> > 
> > [thomas@tmb linux-2.6.27.30]$ LC_ALL=C make
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   CALL    scripts/checksyscalls.sh
> >   CHK     include/linux/compile.h
> >   CC      fs/compat_ioctl.o
> > fs/compat_ioctl.c:1913: error: 'FS_IOC_FIEMAP' undeclared here (not in a 
> > function)
> > make[1]: *** [fs/compat_ioctl.o] Error 1
> > make: *** [fs] Error 2
> 
> indeed, fiemap was merged after 2.6.27, so the patch below was not
> appropriate for 2.6.27.x :
> 
>     [patch 16/28] compat_ioctl: hook up compat handler for FIEMAP ioctl
> 
> Greg, commit 9ac3664242f11fb38ea5029712bc77ee317fe38c should be reverted
> I think.

You are right, I'll do it in the morning and push out another .27 update
with this fix in it.

thanks,

greg k-h
