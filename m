Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbXE2Qtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbXE2Qtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbXE2Qta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:49:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41089 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbXE2Qt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:49:29 -0400
Date: Tue, 29 May 2007 08:58:50 -0700
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Tejun Heo <htejun@gmail.com>, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 2.6.22-rc2-mm1] sysfs: assorted fixes
Message-ID: <20070529155850.GB7068@suse.de>
References: <1180368625600-git-send-email-htejun@gmail.com> <20070529160243.7ea4023d@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529160243.7ea4023d@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 04:02:43PM +0200, Cornelia Huck wrote:
> On Tue, 29 May 2007 01:10:25 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
> > Hello, all.
> > 
> > This patchset contains two cleanups and three fixes.
> > 
> > #01: make-sysfs_alloc_ino-static, cleanup
> > #02: fix-parent-refcounting, fix
> > #03: reorganize-sysfs_new_inode-and-sysfs_create, cleanup and prep for #04
> > #04: use-iget_locked-instead-of-new_inode, fix
> > #05: fix-root-sysfs_dirent-root-dentry-association, fix
> > 
> >  fs/sysfs/dir.c   |  143 +++++++++++++++++++++++--------------------------------
> >  fs/sysfs/inode.c |  114 ++++++++++++++++++++++++-------------------
> >  fs/sysfs/mount.c |   19 ++++---
> >  fs/sysfs/sysfs.h |    6 +-
> >  4 files changed, 137 insertions(+), 145 deletions(-)
> > 
> > Please apply.  Thanks.
> 
> I've tested this patchset a bit on s390 (device attach/detach and
> moving devices around) and didn't encounter problems. As far as I can
> see, this looks sane.

It boots on this laptop just fine too :)

Thanks for testing,

greg k-h
