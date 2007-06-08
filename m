Return-Path: <linux-kernel-owner+w=401wt.eu-S970097AbXFHQK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970097AbXFHQK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966932AbXFHQKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:10:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57985 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764198AbXFHQKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:10:47 -0400
Subject: Re: 2.6.22-rc4-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Valdis.Kletnieks@vt.edu
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Jones <pjones@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6712.1181316818@turing-police.cc.vt.edu>
References: <1181228660.3625.23.camel@lov.localdomain>
	 <46682385.1060802@redhat.com> <20070607154342.GA16911@suse.de>
	 <20070607085200.f8d6e2d3.akpm@linux-foundation.org>
	 <20070607155953.GA17591@suse.de>
	 <20070607090632.cfcf02e6.akpm@linux-foundation.org>
	 <20070607161525.GA18363@suse.de>
	 <20070607184805.GA28551@nostromo.devel.redhat.com>
	 <20070607200102.GA21653@suse.de>
	 <20070607233258.063f6cfa@the-village.bc.nu> <20070607230904.GA7344@suse.de>
	 <6712.1181316818@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 18:10:33 +0200
Message-Id: <1181319033.3625.74.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19dczLzQUI+s6oZqF2lKTxpqx3E93U/6wgiBYU
 Pixd1aLpm72CWcjmP4tv9/VtLxNk5rJKF2GTKNV45XFD/vYU0o
 gfNAnGzTDoCM6gvYvMIRsgqH8oC2OYE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-08 at 11:33 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 07 Jun 2007 16:09:04 PDT, Greg KH said:
> > If CONFIG_SYSFS_DEPRECATED everything should work just fine with all old
> > initrd scripts.  It's only if you enable that option (which is enabled
> > by default) that you need to ensure that your distro has the latest
> > functionality so that everything works properly.
> 
> Can somebody document what an initrd has to do differently?  Some of us
> run with initrd's not created by mkinitrd.

You should be fine if you don't explicitly distinguish between symlinks
and directories.

Or just look what almost everybody is doing in initramfs, Debian,
Gentoo, Ubuntu, SUSE, ..., all use uevent-driven udev bootup there, and
it just works without caring about anything in sysfs or weird timing
issues.

Kay

