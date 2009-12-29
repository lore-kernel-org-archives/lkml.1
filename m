Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbZL2V4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbZL2V4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZL2V4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:56:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40667 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbZL2V4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:56:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: tytso@mit.edu
Subject: Re: [Bug #14936] kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4 partition with ext4
Date: Tue, 29 Dec 2009 22:56:56 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Gene Heskett <gene.heskett@verizon.net>, okias <d.okias@gmail.com>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera> <NJVdobuNFNK.A.-nG.JnhOLB@chimera> <20091229165712.GH4429@thunk.org>
In-Reply-To: <20091229165712.GH4429@thunk.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912292256.56701.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 December 2009, tytso@mit.edu wrote:
> On Tue, Dec 29, 2009 at 04:10:01PM +0100, Rafael J. Wysocki wrote:
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14936
> > Subject		: kernel BUG at fs/ext4/inode.c:1063 if attempted to use non-ext4 partition with ext4
> > Submitter	: Gene Heskett <gene.heskett@verizon.net>
> > Date		: 2009-12-26 14:13 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&m=126183682330809&w=4
> > 		  http://marc.info/?l=linux-kernel&m=126169372613898&w=4
> 
> Bisected to commit d21cd8, and reverting this commit seems to fix the
> problem.  The problem appeared between -rc1 and -rc2.  It was a fix
> that was pushed as part of a quota/ext4 fixes.  For more information:
> 
> http://marc.info/?l=linux-ext4&m=126197233225936&w=2
> 
> I will take a look at this to see if I can find an easy fix;
> otherwise, we'll probably want to revert commit d21cd8 before -rc3.

OK, thanks for the update.

Rafael
