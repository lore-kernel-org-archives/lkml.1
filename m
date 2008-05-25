Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbYEYVDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbYEYVDj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 17:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYEYVDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 17:03:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47263 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYEYVDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 17:03:31 -0400
X-Greylist: delayed 1490 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 May 2008 17:03:31 EDT
Date: Sun, 25 May 2008 22:39:21 +0200
From: Pavel Machek <pavel@suse.cz>
To: Patrick <ragamuffin@datacomm.ch>
Cc: linux-kernel@vger.kernel.org
Subject: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard Disk
	Corruption
Message-ID: <20080525203921.GB18781@elf.ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain> <20080525173825.GA4132@ucw.cz> <1211746106.6188.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211746106.6188.57.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > iommu problem? Try it with mem=3G.
> 
> YES! :-) How did you know?

Guess how... I hit it myself.

> So how are we going to get this fixed???

Write a patch, submit it? ;-).

Okay, I guess I should do the patch, but I can't test it easily. If
you can do testing/some development, I guess I can try to cook up
something.

(But no, I'm not an IOMMU expert).

> Should the IOMMU be reinitialized after resume? Or should the bios do it
> but doesn't? ** On the m2a-vm, the "GART" seems to be used as iommu,
> so... :-) ???

It is a Linux bug. BIOS could be more helpful, but... this is a Linux
problem.

> I put some kernel message logs here:
> http://zefir.freesitespace.net/dmesg/
> One log without mem=4G will also be there shortly, where you will see
> the messages concerning the iommu (which seems to be unused right
> now).

Yep, they are similar to what I see.

> ???** Seems, the SB600 is not to blame - alas sorry for the subject.

Subject is easy to change ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
