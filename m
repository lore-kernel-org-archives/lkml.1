Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZD0SAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZD0SAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbZD0SAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:00:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45778 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZD0SAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:00:32 -0400
Date: Mon, 27 Apr 2009 20:03:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
Message-ID: <20090427180332.GA19265@elf.ucw.cz>
References: <1239654768.6542.10.camel@localhost.localdomain> <20090424221455.GB5342@elf.ucw.cz> <200904271356.21684.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271356.21684.vapier@gentoo.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-04-27 13:56:20, Mike Frysinger wrote:
> On Friday 24 April 2009 18:14:55 Pavel Machek wrote:
> > On Mon 2009-04-13 21:32:48, Adrian McMenamin wrote:
> > > --- /dev/null
> > > +++ b/fs/vmufat/Kconfig
> > > @@ -0,0 +1,14 @@
> > > +config VMUFAT_FS
> > > +	tristate "Dreamcast VMU FAT filesystem"
> > > +	depends on BLOCK
> > > +	help
> > > +	  This implements the simple FAT type filesystem found on SEGA
> > > +	  Dreamcast visual memory units.
> > > +
> > > +	  Dreamcast users who want to mount their VMUs to view the native
> > > +	  filesystem will say 'Y' here. The filesystem is hardware independent
> > > +	  but is not recommended for any serious use in other circumstances, so
> > > +	  just about everyone else should say 'N'.
> > > +
> > > +	  To compile this as a module say 'M' here. The module will be called
> > > +	  vmufat
> >
> > "vmufat.ko." ?
> 
> no, the standard is to name it without extension.  there should be a period 
> there though as it's the end of the sentence ...

Ok, add that period at end of sentence, I stand corrected.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
