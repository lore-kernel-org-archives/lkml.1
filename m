Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZBWExW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZBWExW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 23:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZBWExN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 23:53:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:34177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbZBWExM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 23:53:12 -0500
Date: Sun, 22 Feb 2009 20:35:36 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Federico Cuello <fedux@lugmen.org.ar>,
       Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       bugme-daemon@bugzilla.kernel.org, stable@kernel.org
Subject: Re: [Bug #12610] sync-Regression in 2.6.28.2?
Message-ID: <20090223043536.GC19687@suse.de>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.xTF.As0lJB@chimera> <20090221175646.GB3750@mit.edu> <200902221102.10579.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902221102.10579.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 11:02:09AM +0100, Rafael J. Wysocki wrote:
> On Saturday 21 February 2009, Theodore Tso wrote:
> > On Sat, Feb 14, 2009 at 09:38:18PM +0100, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12610
> > > Subject		: sync-Regression in 2.6.28.2?
> > > Submitter	: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
> > > Date		: 2009-01-27 9:35 (19 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=123304977706620&w=4
> > 
> > This fix for this has landed in mainline post 2.6.29-rc5, as commit
> > 2acf2c.  The deadlock is technically not a regression but it was made
> > *much* more likely to show up because of commit 31a1266: ("mm:
> > write_cache_pages cyclic fix, which show up in 2.6.28.1").  
> > 
> > Commit 3a4c68 in mainline backs up the change made in 31a1266, so you
> > probably won't see this much after 2.6.28.6 (when 3a4c68 was
> > backported to 2.6.28.y), but we should get commit 2acf2c pushed to
> > 2.6.28.x and 2.6.27.y to completely solve the deadlock problem.
> 
> Thanks for the update.
> 
> I'll close the bug since it's fixed in the mainline.  Please tell Greg which
> patches to put into the -stable kernels.

Ted, can you forward the needed patches to stable@kernel.org, or just
tell us to take those git commits directly?

thanks,

greg k-h
