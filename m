Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXFIM64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXFIM64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 08:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbXFIM6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 08:58:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38361 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751831AbXFIM6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 08:58:46 -0400
Date: Sat, 9 Jun 2007 14:58:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 38/45] AppArmor: Module and LSM hooks
Message-ID: <20070609125839.GH27793@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706041342.42178.agruen@suse.de> <20070604131242.GE1971@elf.ucw.cz> <200706041630.49316.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706041630.49316.agruen@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > How will kernel work with very long paths? I'd suspect some problems,
> > if path is 1MB long and I attempt to print it in /proc
> > somewhere.
> 
> Pathnames are only used for informational purposes in the kernel, except in 
> AppArmor of course. /proc only uses pathnames in a few places, 
> but /proc/mounts will silently fail and produce garbage entries. That's not 
> ideal of course; we should fix that somehow.

> Note that this has nothing to do with the AppArmor discussion ...

This has everything to do with AA discussion. You took unreliable,
for-user-info kernel subsystem, and made security subsystem depend on
it. Oops.

> > Perhaps vfs should be modified not to allow such crazy paths? But placing
> > limit in aa is ugly. 
> 
> Dream on. Redefining fundamental vfs semantics is not an option; we should 
> rather make sure that we fail gracefully. Considering the

And instead of fixing "too long pathnames are problem in kernel" in
any clean way, you "simply" included
configurable-but-impossible-to-configure-right limit into
apparmor. And now you want that merged. Dream on.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
