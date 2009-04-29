Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbZD2V7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbZD2V7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZD2V71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:59:27 -0400
Received: from kroah.org ([198.145.64.141]:37450 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650AbZD2V70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:59:26 -0400
Date: Wed, 29 Apr 2009 14:56:23 -0700
From: Greg KH <greg@kroah.com>
To: Valdis.Kletnieks@vt.edu
Cc: Kay Sievers <kay.sievers@vrfy.org>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.81 release
Message-ID: <20090429215623.GA27319@kroah.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> <20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> <ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> <20090429192309.GA15539@kroah.com> <44275.1241041373@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44275.1241041373@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 05:42:53PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 29 Apr 2009 12:23:09 PDT, Greg KH said:
> 
> > Distros ship uppdate-usbids.sh, like they do the same for the pci ids
> > file.  And you can consider the usb.ids file a "config file" :)
> 
> So my Fedora Rawhide box still has usbutils 0.73.  I go snarf usbutils 0.81
> from SourceForge and I find:
> 
> [~/src/usbutils-0.81] ls
> AUTHORS    Makefile.am  aclocal.m4    depcomp     list.h     missing  usbmisc.c
> COPYING    Makefile.in  config.h.in   devtree.c   lsusb-t.c  names.c  usbmisc.h
> ChangeLog  NEWS         configure     devtree.h   lsusb.8    names.h
> INSTALL    README       configure.ac  install-sh  lsusb.c    usb.ids
> [~/src/usbutils-0.81] grep update-usb *
> ChangeLog:      * update-usbids.sh: add "-q" (quiet) option for cron jobs;
> ChangeLog:      * update-usbids.sh:  add, based on update-pciids.sh
> [~/src/usbutils-0.81] 
> 
> So it's not in the tarball, and it's apparently not created by the Makefile.
> 
> So where is it?

As was pointed out by Mike, a bug in the Makefile prevented it from
being added to the tarball.

If youreally want it, you can grab it from the git tree, or wait a day
or so for me to implement Mike's changes he so nicely sent me, so I can
do a new release.

thanks,

greg k-h
