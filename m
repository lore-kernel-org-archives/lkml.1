Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbXICQUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbXICQUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbXICQUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 12:20:22 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40298 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbXICQUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 12:20:21 -0400
Date: Mon, 3 Sep 2007 12:18:41 -0400
Message-Id: <200709031618.l83GIfsU005109@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Al Boldi <a1426z@gawab.com>
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de
Subject: Re: [GIT PULL -mm] Unionfs/fsstack/eCryptfs updates/cleanups/fixes 
In-reply-to: Your message of "Mon, 03 Sep 2007 06:48:20 +0300."
             <200709030648.20267.a1426z@gawab.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <200709030648.20267.a1426z@gawab.com>, Al Boldi writes:
> Josef 'Jeff' Sipek wrote:
> > The following is a series of patches related to Unionfs, which include
> > three small VFS/fsstack patches and one eCryptfs patch; the rest are
> > Unionfs patches.  The patches here represent several months of work and
> > testing under various conditions, especially low-memory, SMP, and
> > preemption situations with an assortment of lower systems: ext2/3/4, xfs,
> > reiserfs, nfs, jffs2, ramfs, tmpfs, cramfs, and squashfs.
> 
> To increase test-usage, it may be critical to always backport at least to
> the latest stable release, like 2.6.22.
> 
> Thanks!
> 
> --
> Al

Al, we have back-ports of the latest Unionfs to 2.6.{22,21,20,19,18,9}, all
in http://unionfs.filesystems.org/.  Before we release any change, we test
it on all back-ports as well as the latest -rc/-mm code base (takes over 24
hours straight to get through all of our regressions :-)

So we'd be happy to submit those patches to the latest stable kernel.  But,
are you talking about VFS/ecryptfs patches (which are in the stable kernel),
or are you talking about Unionfs (which is not)?

Thanks,
Erez.
