Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbZL3Vvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbZL3Vvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZL3Vvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:51:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZL3Vvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:51:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tytso@mit.edu
Subject: Re: [Bug #14936] kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4 partition with ext4
Date: Wed, 30 Dec 2009 22:52:12 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Gene Heskett <gene.heskett@verizon.net>, okias <d.okias@gmail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <20091229165712.GH4429@thunk.org> <20091230190120.GQ4429@thunk.org>
In-Reply-To: <20091230190120.GQ4429@thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912302252.12140.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 December 2009, tytso@mit.edu wrote:
> On Tue, Dec 29, 2009 at 11:57:12AM -0500, tytso@MIT.EDU wrote:
> > On Tue, Dec 29, 2009 at 04:10:01PM +0100, Rafael J. Wysocki wrote:
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14936
> > > Subject		: kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4 partition with ext4
> > > Submitter	: Gene Heskett <gene.heskett@verizon.net>
> > > Date		: 2009-12-26 14:13 (4 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=126183682330809&w=4
> > > 		  http://marc.info/?l=linux-kernel&m=126169372613898&w=4
> > 
> > Bisected to commit d21cd8, and reverting this commit seems to fix the
> > problem.  The problem appeared between -rc1 and -rc2.  It was a fix
> > that was pushed as part of a quota/ext4 fixes.  For more information:
> > 
> > http://marc.info/?l=linux-ext4&m=126197233225936&w=2
> > 
> > I will take a look at this to see if I can find an easy fix;
> > otherwise, we'll probably want to revert commit d21cd8 before -rc3.
> 
> I'm working on a fix, and have a proposed patch.  See the thread on
> linux-ext4 here:
> 
> http://marc.info/?l=linux-kernel&m=126219515024315&w=2
> 
> This patch also fixes the dq_claim_space kerneloops problem as
> well....

Thanks, I've added your patch to the Bugzilla entry.

Rafael
