Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbYAYXOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbYAYXOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757693AbYAYXNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:13:13 -0500
Received: from ns2.suse.de ([195.135.220.15]:53642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761456AbYAYXNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:13:10 -0500
Date: Fri, 25 Jan 2008 15:11:29 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: compile error in current git
Message-ID: <20080125231129.GD25074@suse.de>
References: <479A4867.9040302@goop.org> <20080125221731.GB15172@suse.de> <20080125150002.09cdacb8.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125150002.09cdacb8.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 03:00:02PM -0800, Randy Dunlap wrote:
> On Fri, 25 Jan 2008 14:17:31 -0800 Greg KH wrote:
> 
> > On Fri, Jan 25, 2008 at 12:36:55PM -0800, Jeremy Fitzhardinge wrote:
> > > When compiling current git with CONFIG_BLOCK disabled, I'm seeing this 
> > > compile error:
> > >
> > >  CC      drivers/base/core.o
> > > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c: In function 
> > > ???device_add_class_symlinks???:
> > > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: 
> > > ???part_type??? undeclared (first use in this function)
> > > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: (Each 
> > > undeclared identifier is reported only once
> > > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:655: error: for each 
> > > function it appears in.)
> > > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c: In function 
> > > ???device_remove_class_symlinks???:
> > > /home/jeremy/hg/xen/paravirt/linux/drivers/base/core.c:728: error: 
> > > ???part_type??? undeclared (first use in this function)
> > > make[4]: *** [drivers/base/core.o] Error 1
> > 
> > Hm, I thought we fixed the CONFIG_BLOCK disabled issues with Randy's
> > older patch.  Randy, wasn't this already addressed somehow?
> 
> My earlier email fixed one problem but noted that there were
> still some other issues.

Ah, sorry, I missed that "note" :(

thanks,

greg 'time to get that make randconfig system up and working' k-h
