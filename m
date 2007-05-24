Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbXFANVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbXFANVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbXFANVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:21:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4806 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754663AbXFANVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:21:19 -0400
Date: Thu, 24 May 2007 14:47:27 +0000
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-usenet@taverner.cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070524144726.GB3920@ucw.cz>
References: <653438.15244.qm@web36612.mail.mud.yahoo.com> <20070529144518.GD5840@ucw.cz> <Pine.LNX.4.64.0705291622430.31474@asgard.lang.hm> <20070529233041.GC24200@elf.ucw.cz> <f3il25$pcp$1@taverner.cs.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3il25$pcp$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(Please do not drop me from cc list when replying).

> > no, this won't help you much against local users, [...]
> 
> Pavel Machek  wrote:
> >Hmm, I guess I'd love "it is useless on multiuser boxes" to become
> >standard part of AA advertising.
> 
> That's not quite what david@ said.  As I understand it, AppArmor is not
> focused on preventing attacks by local users against other local users;
> that's not the main problem it is trying to solve.  Rather, it's primary
> purpose is to deal with attacks by remote bad guys against your network
> servers.  That is a laudable goal.

It is also not going to prevent local users attacking network servers.
Local users can ln arbitrary files, and then play tricks with network
servers.

> This means that AppArmor could still be useful on multiuser boxes,
> even if that utility is limited to defending (some) network daemons
> against remote attack (or, more precisely, reducing the damage done by
> a successful remote attack against a network daemon).


Yes, if there's significantly more remote bad guys than local bad
guys, and if remote bad guys can't just get some local user first, AA
still has some value.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
