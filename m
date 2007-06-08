Return-Path: <linux-kernel-owner+w=401wt.eu-S1031941AbXFHUe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031941AbXFHUe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968792AbXFHUes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:34:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1977 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753061AbXFHUer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:34:47 -0400
Date: Fri, 8 Jun 2007 20:24:01 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070608202400.GA4005@ucw.cz>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <f3il25$pcp$1@taverner.cs.berkeley.edu> <20070524144726.GB3920@ucw.cz> <12508.1180719875@turing-police.cc.vt.edu> <f3qrp6$ftn$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3qrp6$ftn$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(Please preserve cc lists when replying on l-k).

> >Experience over on the Windows side of the fence indicates that "remote bad
> >guys get some local user first" is a *MAJOR* part of the current real-world
> >threat model - the vast majority of successful attacks on end-user boxes these
> >days start off with either "Get user to (click on link|open attachment)" or
> >"Subvert the path to a website (either by hacking the real site or hijacking
> >the DNS) and deliver a drive-by fruiting when the user visits the page".
> 
> AppArmor isn't trying to defend everyday users from getting phished or
> social engineered; it is trying to protect servers from getting rooted
> because of security holes in their network daemons.  I find that a
> laudable goal.  Sure, it doesn't solve every security problem in the
> world, but so what?  A tool that could solve that one security problem

AA solves less problems than SELinux does. Some people like AA more,
but I guess they should just learn SELinux.

And yes, I'm afraid this discussion is relevant on l-k, because we
should have very good reasons before merging duplicate functionality.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
