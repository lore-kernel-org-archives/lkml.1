Return-Path: <linux-kernel-owner+w=401wt.eu-S934030AbXHYV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934030AbXHYV7x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 17:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXHYV7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 17:59:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56549 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXHYV7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 17:59:46 -0400
Date: Sat, 25 Aug 2007 22:59:45 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] FS: Make RAMFS both selectable and tristate.
Message-ID: <20070825215945.GC21089@ftp.linux.org.uk>
References: <Pine.LNX.4.64.0708251538320.29214@localhost.localdomain> <20070825212920.GB21089@ftp.linux.org.uk> <Pine.LNX.4.64.0708251736050.12852@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708251736050.12852@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2007 at 05:40:00PM -0400, Robert P. J. Day wrote:
> On Sat, 25 Aug 2007, Al Viro wrote:
> 
> > On Sat, Aug 25, 2007 at 03:40:23PM -0400, Robert P. J. Day wrote:
> > >
> > > Allow RAMFS to be user-selectable, and to be built as a module.
> > >
> > > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> > >
> > > ---
> > >
> > >   given that the help content for that option suggests it can be built
> > > as a module, it just makes sense to make it selectable and tristate,
> > > unless someone has a compelling argument against it.
> >
> > How about "check if the kernel builds if you do that"?
> 
> i did.  i did a simple "make defconfig" and "make", and the kernel
> built fine.  that patch didn't change the status of RAMFS in any way,
> it was still selected as default "y", so why would that patch have
> made any difference to the eventual build?

Your patch allows to make it a module.  That seems to be the only point of
your patch.  So check if it builds when RAMFS is made "m" or "n".
