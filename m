Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbXE2OGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbXE2OGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbXE2OCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:02:47 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:40389 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760776AbXE2OCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:02:45 -0400
Date: Tue, 29 May 2007 16:02:43 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, dmitry.torokhov@gmail.com, oneukum@suse.de,
       rpurdie@rpsys.net, stern@rowland.harvard.edu, maneesh@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 2.6.22-rc2-mm1] sysfs: assorted fixes
Message-ID: <20070529160243.7ea4023d@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1180368625600-git-send-email-htejun@gmail.com>
References: <1180368625600-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 01:10:25 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Hello, all.
> 
> This patchset contains two cleanups and three fixes.
> 
> #01: make-sysfs_alloc_ino-static, cleanup
> #02: fix-parent-refcounting, fix
> #03: reorganize-sysfs_new_inode-and-sysfs_create, cleanup and prep for #04
> #04: use-iget_locked-instead-of-new_inode, fix
> #05: fix-root-sysfs_dirent-root-dentry-association, fix
> 
>  fs/sysfs/dir.c   |  143 +++++++++++++++++++++++--------------------------------
>  fs/sysfs/inode.c |  114 ++++++++++++++++++++++++-------------------
>  fs/sysfs/mount.c |   19 ++++---
>  fs/sysfs/sysfs.h |    6 +-
>  4 files changed, 137 insertions(+), 145 deletions(-)
> 
> Please apply.  Thanks.

I've tested this patchset a bit on s390 (device attach/detach and
moving devices around) and didn't encounter problems. As far as I can
see, this looks sane.
