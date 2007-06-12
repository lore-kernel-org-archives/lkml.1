Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbXFLNGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbXFLNGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 09:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbXFLNGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 09:06:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51232 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755528AbXFLNGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 09:06:38 -0400
Date: Tue, 12 Jun 2007 15:06:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Message-ID: <20070612130630.GA11880@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706041630.49316.agruen@suse.de> <20070609125839.GH27793@elf.ucw.cz> <200706091544.31971.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706091544.31971.agruen@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > How will kernel work with very long paths? I'd suspect some problems,
> > > > if path is 1MB long and I attempt to print it in /proc
> > > > somewhere.
> > > 
> > > Pathnames are only used for informational purposes in the kernel, except 
> > > in AppArmor of course. /proc only uses pathnames in a few places, 
> > > but /proc/mounts will silently fail and produce garbage entries. That's 
> > > not ideal of course; we should fix that somehow.
> > 
> > > Note that this has nothing to do with the AppArmor discussion ...
> > 
> > This has everything to do with AA discussion.
> 
> How pathnames are used in /proc has *nothing* to do with AppAmor.
> 
> > You took unreliable, for-user-info kernel subsystem, and made security
> > subsystem depend on it. Oops.
> 
> Wrong. I said that the kernel uses pathnames for informational purposes only, 
> not that they are unreliable. Don't turn words around in my

Well, we know they are unreliable from other sources.

> The pathnames that d_path computes exactly reflect what the dcache knows. 
> (This requires the d_path fixes that are included in the AppArmor series and 
> have also been posted independently, and the reasons why these fixes are 
> needed are well explained in the mails.) The resulting pathnames are anything 
> but unreliable.

Yes?

Like... everything but AA works with very long paths?

Like... deleted files handling, where AA used to pick random name?

Like... races during tree renames, where AA may use name file never
ever had?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
