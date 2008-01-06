Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYAFMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYAFMGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbYAFMGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:06:00 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:48904 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbYAFMF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:05:59 -0500
Date: Sun, 6 Jan 2008 14:05:27 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Sam Ravnborg <sam@ravnborg.org>,
       Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage
	support
Message-ID: <20080106120527.GC2082@does.not.exist>
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org> <47801126.7020807@oracle.com> <4780C15C.2000904@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4780C15C.2000904@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 12:54:04PM +0100, Stefan Richter wrote:
> Randy Dunlap wrote:
> > Sam Ravnborg wrote:
> >> On Sat, Jan 05, 2008 at 11:03:30PM +0200, Adrian Bunk wrote:
> >>> For kconfig users, "select" is _much_ better than sending them
> >>> through different menus.
> >> Only if used within the current limitations of Kconfig.
> >> And that requires you to use select only to select symbols with
> >> no dependencies.
> > 
> > Right.  One of the main (or maybe even the only) problem(s) is
> > that select does not follow dependency chains.
> > and that no one works on that problem.
> > 
> >> In this case we do not know if BLOCK is enabled or not.
> > 
> > For Aunt Tillie cases, "select" makes sense.  For other cases,
> > I'd argue that it makes sense for config users to know when they
> > do something that causes an entire subsystem to be added to their
> > kernel (like SCSI or NET).
> 
> Besides the issue of additional potentially unsatisfied dependencies and
> the issue of things being enabled behind the user's back --- there is
> another issue which Adrian and Al ignore:
> 
> The user who wants to enable usb-storage /has/ to go into the SCSI menu
> anyway to answer whether he needs sd, sr, st, sg, command logging...

That's a different UI problem that has to be fixed.

The "SCSI support type" menu has to move out of the SCSI menu.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

