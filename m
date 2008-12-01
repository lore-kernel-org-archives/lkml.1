Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbYLAG4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbYLAG4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLAG4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:56:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46986
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbYLAG4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:56:44 -0500
Date: Sun, 30 Nov 2008 22:56:44 -0800 (PST)
Message-Id: <20081130.225644.217658360.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/32] of_platform_driver noise on sparce
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081126.010541.158438052.davem@davemloft.net>
References: <E1L3wNs-0006R4-JQ@ZenIV.linux.org.uk>
	<20081126.010541.158438052.davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 26 Nov 2008 01:05:41 -0800 (PST)

Linus, just a note.

I don't know what the point of my reviewing and replying to Al's
patches is, if you're going to apply them anyways.

I also applied all of his other sparc64 patches (the ones I did think
were OK), but I did so to my sparc-next-2.6 tree, as none of this
stuff really needs to go into 2.6.28 at this point.

I've already broken sparc32 by mistake with some section annotation
"fixes" I thought were obvious.  So it's just not worth the risk in
my opinion.

And I gave suitable "applied" responses to those postings as well.

Yet you applied those to your tree directly too.

Sure, if the changes are OK, you applying them directly is fine.
But I did NAK this one specifically.

Again, just FYI...

> From: Al Viro <viro@ftp.linux.org.uk>
> Date: Sat, 22 Nov 2008 17:35:04 +0000
> 
> > 
> > switch to __init for those; unlike powerpc sparc has no hotplug support
> > for that stuff and their ->probe() tends to call __init functions while
> > being declared __devinit.
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >  arch/sparc64/kernel/pci_fire.c   |    2 +-
> >  arch/sparc64/kernel/pci_psycho.c |    4 ++--
> >  arch/sparc64/kernel/pci_sun4v.c  |    2 +-
> >  drivers/sbus/char/bbc_i2c.c      |    6 +++---
> >  sound/sparc/cs4231.c             |   10 +++++-----
> >  5 files changed, 12 insertions(+), 12 deletions(-)
> 
> There's tons of sparc specific drivers not handled here.
> For example, drivers/scsi/sun_esp.c, drivers/scsi/qlogicpti.c,
> and on and on and on.
> 
> In fact there are more sparc specific drivers using
> of_platform_driver under drivers/ thans powerpc :)
> 
> I don't think I want to do this for now, sorry Al.
