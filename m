Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbXFOXkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbXFOXkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbXFOXkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:40:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40953 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752686AbXFOXkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:40:04 -0400
Date: Sat, 16 Jun 2007 01:39:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070615233914.GF2616@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615233314.GN3564@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615233314.GN3564@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Yes, you may get some -EPERM during the tree move, but AA has that
> > problem already, see that "when madly moving trees we sometimes
> > construct path file never ever had".
> 
> Pavel, please focus on the current AppArmor implementation. You're
> remembering a flaw with a previous version of AppArmor. The pathnames
> constructed with the current version of AppArmor are consistent and
> correct.

Ok, I did not know that this got fixed.

How do you do that? Hold a lock preventing renames for a whole time
you walk from file to the root of filesystem?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
