Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbYIBJWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbYIBJWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYIBJWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:22:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47058 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYIBJWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:22:30 -0400
Date: Tue, 2 Sep 2008 10:05:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: Patrick <ragamuffin@datacomm.ch>
Cc: Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard
	Disk Corruption
Message-ID: <20080902080535.GC15399@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain> <200806090036.32267.rjw@sisk.pl> <1213184587.6376.37.camel@localhost.localdomain> <200806111638.50933.rjw@sisk.pl> <484FE97D.4040805@firstfloor.org> <1215106548.5194.22.camel@localhost.localdomain> <20080807081747.GC1647@elf.ucw.cz> <1218235204.5590.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218235204.5590.20.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Can you test 2.6.27-rc2? It should be all there...
> 
> Ja, sure! I noticed that it's there already... thank you all!
> 
> So as you requested, I got myself a -rc2 tree, compiled and tested
> #s2ram and #s2disk. It works!

Good.

> Maybe it's got something to do with the fact that I'm using
> https://launchpad.net/~xorg-edgers xserver now to have 3d acceleration
> working for my radeon X1200 (RS690 builtin) and the drm module versions
> don't match. Xserver wants 1.30 but starts anyway. I can't fix this
> because the script can't compile the
> git://anongit.freedesktop.org/git/mesa/drm modules for 2.6.27-rc2 ....
> This creates some unpredictable problems with the X server process when
> I log into my account (can't find out what triggers it ... cpu usage
> goes to 100%, have to reboot) As a workaround, I could log into a guest
> account to do the tests but switched back to my patched 2.6.26-rc5 for
> now for everyday PC usage.

Yes, 3d has some problems.

> BTW, if somebody would like to explain to me, why the simultanious usage
> of the GART by drm and as iommu DON'T bite each other, I'd be quiet
> interrested to learn.

No idea, sorry.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
