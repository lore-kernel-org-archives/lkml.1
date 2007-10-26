Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbXJZUAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbXJZUAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbXJZT76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:59:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48080 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbXJZT75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:59:57 -0400
Date: Fri, 26 Oct 2007 12:15:34 -0700
From: Greg KH <greg@kroah.com>
To: Amit Shah <amitshah@gmx.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
Message-ID: <20071026191534.GA24596@kroah.com>
References: <877aabc40710260014v220ab804o5de5dbc36b870bd1@mail.gmail.com> <20071026155058.GC23016@kroah.com> <877aabc40710261025v2f53423el6bb63fc2024a0ffd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877aabc40710261025v2f53423el6bb63fc2024a0ffd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 10:55:15PM +0530, Amit Shah wrote:
> On 26/10/2007, Greg KH <greg@kroah.com> wrote:
> > On Fri, Oct 26, 2007 at 12:44:38PM +0530, Amit Shah wrote:
> > > On 2.6.24-rc1, I get this for all my eth interfaces:
> > >
> > > [  150.389821] sysfs: duplicate filename 'eth1_rename' can not be created
> > > [  150.389824] WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> >
> > I sent out the patch below for comments, yet no one did :(
> >
> > Can you try it out and let me know if it works for you or not?
> 
> No, doesn't help.

Ugh, thanks.  There's got to be something else going on in the network
layer with this.

I'll try to reproduce it on a different distro on a different box later
this afternoon...

thanks,

greg k-h
