Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab0BBVLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:11:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325Ab0BBVLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:11:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [Bug #14949] drm_vm.c:drm_mmap: possible circular locking dependency detected
Date: Tue, 2 Feb 2010 22:12:34 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg KH <greg@kroah.com>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <201002022146.45078.rjw@sisk.pl> <20100202205857.GA30024@liondog.tnic>
In-Reply-To: <20100202205857.GA30024@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002022212.34179.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010, Borislav Petkov wrote:
> (Adding Greg to Cc:)
> 
> On Tue, Feb 02, 2010 at 09:46:45PM +0100, Rafael J. Wysocki wrote:
> > On Monday 01 February 2010, Borislav Petkov wrote:
> > > On Mon, Feb 1, 2010 at 1:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > >
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > > (either way).
> > > >
> > > >
> > > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14949
> > > > Subject         : drm_vm.c:drm_mmap: possible circular locking dependency detected
> > > > Submitter       : Borislav Petkov <petkovbb@googlemail.com>
> > > > Date            : 2009-12-26 9:45 (37 days old)
> > > > References      : http://marc.info/?l=linux-kernel&m=126182073616279&w=4
> > > > Handled-By      : Eric W. Biederman <ebiederm@aristanetworks.com>
> > > > Patch           : http://patchwork.kernel.org/patch/70461/
> > > 
> > > Yes, this is fixed.
> > 
> > Do you mean "fixed" as "the fix is in the Linus' tree" or "fixed" as "the
> > patch fixed it for me"?
> 
> Rather the second one, i.e. it fixes it for me. The patch is named
> 
> sysfs-cache-the-last-sysfs_dirent-to-improve-readdir-scalability-v2.patch
> 
> and is "stuck" in Greg's tree. Judging by the quilt series¹, the patch
> is slated for submission after 2.6.33. This late in the game for .32,
> I'm guessing maybe a stable backport after .33 is out?

I guess so.  Thanks!

Rafael
