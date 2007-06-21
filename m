Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbXFUSAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbXFUSAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758870AbXFUSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:00:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55874 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757767AbXFUSAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:00:09 -0400
Date: Thu, 21 Jun 2007 19:59:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Greg KH <greg@kroah.com>, Crispin Cowan <crispin@novell.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621175955.GJ18392@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <46732124.80509@novell.com> <20070615234925.GB15056@kroah.com> <200706211801.05834.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706211801.05834.agruen@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-06-21 18:01:05, Andreas Gruenbacher wrote:
> On Saturday 16 June 2007 01:49, Greg KH wrote:
> > But for those types of models that do not map well to internal kernel
> > structures, perhaps they should be modeled on top of a security system that
> > does handle the internal kernel representation of things in the way the
> > kernel works.
> 
> How exactly are struct vfsmount and struct dentry not in-kernel structures?

That's what greg is talking about, AFAICT. Normal kernel code uses
struct vfsmount + struct dentry.

AA uses... guess what... char pathname[HUGE_VALUE].
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
