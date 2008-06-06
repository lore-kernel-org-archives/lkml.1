Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYFFNZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYFFNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYFFNZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:25:17 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1260 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754231AbYFFNZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:25:16 -0400
Date: Fri, 6 Jun 2008 15:20:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Patrick <ragamuffin@datacomm.ch>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: >3G => iommu => suspend problems -- was Re: SB600 AHCI: Hard Disk Corruption
Message-ID: <20080606132011.GA9027@ucw.cz>
References: <1211717435.6038.53.camel@localhost.localdomain> <1211815881.6140.19.camel@localhost.localdomain> <20080527112236.GA13957@elf.ucw.cz> <200806040033.20736.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806040033.20736.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Can you try this one? It should prevent suspend in the broken cases,
> > > > but allow it in mem=4G config.
> > > 
> > > Sure!
> > > 
> > > root@babar:/usr/src/linux-2.6.25# patch -p1 < /home/pat/patch-2.6.26-rc3.gart-suspend
> > > patching file arch/x86/kernel/pci-gart_64.c
> > > Hunk #4 succeeded at 629 with fuzz 2 (offset 11 lines).
> > > 
> > > .....make; cp bzImage /boot; reboot....
> > 
> > Thanks!
> > 
> > This goes on top of the second patch... it makes it work.
> > 
> > 								Pavel
> > 
> > For iommu suspend/resume code to work, functions it calls may not be
> > __init.
> > 
> > Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> I consolidated some of your patches sent in this thread and made the result
> apply to the current -git.  It hasn't been tested yet, but does it look good?
> 
> It's on top of the patch that adds the GART sysdev.

Looks ok to me.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
