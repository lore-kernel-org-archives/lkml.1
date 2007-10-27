Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbXJ0G1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbXJ0G1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbXJ0G1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:27:36 -0400
Received: from ns1.suse.de ([195.135.220.2]:59978 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbXJ0G1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:27:36 -0400
Date: Fri, 26 Oct 2007 23:32:22 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-2.6.23-git3: Many sysfs-related warnings in dmesg
Message-ID: <20071027063222.GA3478@suse.de>
References: <47221E6F.1090607@lwfinger.net> <1193422064.2190.6.camel@lov.site> <20071027023612.GC28858@suse.de> <1193465294.2190.51.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193465294.2190.51.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 08:08:14AM +0200, Kay Sievers wrote:
> On Fri, 2007-10-26 at 19:36 -0700, Greg KH wrote:
> > On Fri, Oct 26, 2007 at 08:07:44PM +0200, Kay Sievers wrote:
> > > On Fri, 2007-10-26 at 12:05 -0500, Larry Finger wrote:
> > > > On my openSUSE 10.3 x86_64 system running v2.6.24-rc1-281-g22d2aa1,
> > > > I get the sysfs rename messages.
> > > 
> > > Care to try this? Seems like a silly bug in the core if
> > > SYSFS_DEPRECATED=y. That's why we didn't catch this earlier, sorry.
> 
> > > From: Kay Sievers <kay.sievers@vrfy.org>
> > > Subject: Driver Core: fix bug in device_rename() for SYSFS_DEPRECATED=y
> > > 
> > 
> > Do you have some more information for the change log here?  Are we just
> > not unwinding from errors properly?
> 
> The code just shouldn't run if class devices are real directories, it's
> an update for the symlink in the class directory. Nobody noticed that as
> long as the creation of sysfs files silently failed, and we both missed
> it before the merge, because we don't run SYSFS_DEPRECATED=y.

Ah, thanks, that makes sense.

greg k-h
