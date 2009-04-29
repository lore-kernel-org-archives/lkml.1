Return-Path: <linux-kernel-owner+w=401wt.eu-S1760699AbZD2V6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699AbZD2V6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757549AbZD2V5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:57:49 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:48506 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbZD2V5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:57:48 -0400
MIME-Version: 1.0
In-Reply-To: <44275.1241041373@turing-police.cc.vt.edu>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> 
	<ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> 
	<20090429192309.GA15539@kroah.com> <44275.1241041373@turing-police.cc.vt.edu>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 23:57:27 +0200
Message-ID: <ac3eb2510904291457xf0ccf79y70b1db509effff96@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Valdis.Kletnieks@vt.edu
Cc: Greg KH <greg@kroah.com>, Mike Frysinger <vapier.adi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 23:42,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 29 Apr 2009 12:23:09 PDT, Greg KH said:
>
>> Distros ship uppdate-usbids.sh, like they do the same for the pci ids
>> file.  And you can consider the usb.ids file a "config file" :)
>
> So my Fedora Rawhide box still has usbutils 0.73.  I go snarf usbutils 0.81
> from SourceForge and I find:
>
> [~/src/usbutils-0.81] ls
> AUTHORS    Makefile.am  aclocal.m4    depcomp     list.h     missing  usbmisc.c
> COPYING    Makefile.in  config.h.in   devtree.c   lsusb-t.c  names.c  usbmisc.h
> ChangeLog  NEWS         configure     devtree.h   lsusb.8    names.h
> INSTALL    README       configure.ac  install-sh  lsusb.c    usb.ids
> [~/src/usbutils-0.81] grep update-usb *
> ChangeLog:      * update-usbids.sh: add "-q" (quiet) option for cron jobs;
> ChangeLog:      * update-usbids.sh:  add, based on update-pciids.sh
> [~/src/usbutils-0.81]
>
> So it's not in the tarball, and it's apparently not created by the Makefile.
>
> So where is it?

Only in the source tree:
  http://git.kernel.org/?p=linux/kernel/git/gregkh/usbutils.git;a=tree
not in the tarball. Next version will have it.

Kay
