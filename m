Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbXEPClX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbXEPClX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 22:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760173AbXEPClQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 22:41:16 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:47475 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759779AbXEPClP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 22:41:15 -0400
Date: Wed, 16 May 2007 11:41:01 +0900
From: Mattia Dongili <malattia@linux.it>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: Fwd: Re: Linux 2.6.22-rc1
Message-ID: <20070516024101.GC3971@inferi.kami.home>
References: <Pine.LNX.4.61.0705131123280.9570@yvahk01.tjqt.qr> <20070514015541.GB4800@inferi.kami.home> <Pine.LNX.4.61.0705140742350.9570@yvahk01.tjqt.qr> <20070514104546.10a4368f.randy.dunlap@oracle.com> <20070515154208.GJ5043@inferi.kami.home> <20070515104621.a4e0e609.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515104621.a4e0e609.randy.dunlap@oracle.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc7-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 10:46:21AM -0700, Randy Dunlap wrote:
> On Wed, 16 May 2007 00:42:08 +0900 Mattia Dongili wrote:
...
> > Given the drivers/acpi/Kconfig portion
> > 
> >   if ACPI
> >   ...
> >   config ACPI_EC
> >           bool
> >           default y
> >           help
> >             ...
> >   
> >   config ACPI_POWER
> >           bool
> >           default y
> >   
> >   config ACPI_SYSTEM
> >           bool
> >           default y
> >           help
> > 	  ...
> >   ...
> >   endif
> > 
> > I'd expect the 3 symbols to be all set when CONFIG_ACPI=y.
> > What am I overseeing?
> 
> I think that this is just 'make randconfig' throwing a curve ball.
> ACPI depends on PM, but PM=n.  In my experience, randconfig is a
> good tool for testing oddball configs, but the results are not
> always something that is fixable or needs to be fixed.

It looks like Kconfig does the right thing on i386 though. Not the same
on x84_64.

-- 
mattia
:wq!
