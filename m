Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYFAOSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYFAOSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYFAORV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:17:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4389 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752098AbYFAOQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:16:55 -0400
Date: Sat, 31 May 2008 10:38:08 +0200
From: Pavel Machek <pavel@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Chris Mason <chris.mason@oracle.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080531083807.GJ5405@ucw.cz>
References: <1211995212.3445.52.camel@localhost.localdomain> <20080528150837.685aa677@bree.surriel.com> <200805281615.55386.chris.mason@oracle.com> <Pine.LNX.4.64.0805291224470.6718@jikos.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805291224470.6718@jikos.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > One motivation here is to bring bug reporters from active distro 
> > communities into testing mainline kernels as well.
> 
> My experience from handling both distro-reported and upstream-reported 
> bugs shows that these two worlds/communitites are really quite different 
> in their nature.
> 
> Bug reporters who report bug in the vanilla kernel are usually perfectly 
> fine when someone sends them patch to test, they don't have any problem 
> recompiling the patched kernel, testing, and reporting back.
> 
> This is not the case with distro kernel bug reporters at all. You usually 
> can't just tell them "hey, this patch might fix it, report back if it 
> does". Vast majority of theese users expect the kernel package built for 
> their distro to be provided, so that they can easily install it and test 
> it, but requiring any other effort usually doesn't work.

I guess this would be helped if we actually made compiling distro
kernel easy.

Default suse installation does not even contain gcc; I'm not sure if
we provide our kernel in easy-to-use git form, and I don't think many
suse people would be able to create kernel .rpm without help of
autobuild system... autobuild only works behind suse firewall and
buildservice is not really right answer either.

Having compile-me-kernel script that does all the neccessary steps of
compiling/installing distro kernel with custom patches would be great
way forward...

Plus, we do very little q&a on distro kernel w.r.t to non-standard
.config files. Improving that would be some work, but there would be
chance for 'disable CONFIG_NO_HZ and see if it helps' kind of
debugging.

Oh and having make prepare-kernel-for-this-distro in vanilla would
help a lot, too. Usually, vanilla boots and works on distro with
suitable config, but finding that config is not too easy.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
