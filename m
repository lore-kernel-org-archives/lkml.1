Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbXFDLfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbXFDLfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 07:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbXFDLf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 07:35:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55201 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752704AbXFDLf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 07:35:27 -0400
Date: Mon, 4 Jun 2007 13:35:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Message-ID: <20070604113519.GA6710@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200705231816.46197.agruen@suse.de> <20070604105526.GE4363@elf.ucw.cz> <200706041325.30817.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706041325.30817.agruen@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-04 13:25:30, Andreas Gruenbacher wrote:
> On Monday 04 June 2007 12:55, Pavel Machek wrote:
> > On Wed 2007-05-23 18:16:45, Andreas Gruenbacher wrote:
> > > On Tuesday 15 May 2007 11:14, Pavel Machek wrote:
> > > > Why is this configurable?
> > >
> > > The maximum length of a pathname is an arbitrary limit: we don't want to
> > > allocate arbitrary amounts of of kernel memory for pathnames so we
> > > introduce this limit and set it to a reasonable value. In the unlikely
> > > case that someone uses insanely long pathnames, this limit can be
> > > increased.
> >
> > vfs does not have configurable pathname limit, and I do not see what
> > is so special about AA to require this kind of uglyness.
> 
> You very well know that the vfs has a limit of PATH_MAX characters (4096) for 
> pathnames. This means that at most that many characters can be passed at 
> once. 

Sorry then. Why not reuse the PATH_MAX when it exists already?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
