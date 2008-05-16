Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYEPMDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYEPMDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 08:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYEPMDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 08:03:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:55047 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYEPMDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 08:03:43 -0400
Date: Fri, 16 May 2008 14:04:37 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bill Nottingham <notting@redhat.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Problems with suspend and USB storage
Message-ID: <20080516120437.GC22264@elf.ucw.cz>
References: <20080515163315.GA17779@nostromo.devel.redhat.com> <200805152140.43292.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805152140.43292.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I've been testing suspend/hibernate with various USB devices under
> > 2.6.25.2. Test box is a Thinkpad T60 (uhci, ehci).
> > The results are somewhat dismal.
> > 
> > Using USB as a hibernate device:
> > - A directly connected USB stick works OK as a hibernate device
> > - A directly connected USB hard drive works OK as a hibernate device
> > - A USB stick connected via an ExpressCard reader does not - it appears
> >   to just not be there when the hibernate code attemps to write
> >   the data.
> > 
> > On resume (from either hibernate or suspend from RAM):
> > - Any 'in use' USB storage, whether it be as swap (a hibernate device),
> >   or a mounted filesystem, immediately generates errors on resume. It
> >   appears the filesystem and/or swap tasks are woken up before the
> >   actual USB device - it enumerates the disks after the errors have
> >   already been thrown.

swsusp or uswsusp?

Does strategic delay help?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
