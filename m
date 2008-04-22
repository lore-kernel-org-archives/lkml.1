Return-Path: <linux-kernel-owner+w=401wt.eu-S932120AbYDVVOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbYDVVOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 17:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbYDVVO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 17:14:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756344AbYDVVO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 17:14:29 -0400
Date: Tue, 22 Apr 2008 16:08:47 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] dlm updates for 2.6.26
Message-ID: <20080422210847.GB14594@redhat.com>
References: <20080422135116.GA14594@redhat.com> <alpine.LFD.1.10.0804221344470.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221344470.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:46:54PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 22 Apr 2008, David Teigland wrote:
> > 
> > Please pull dlm updates for 2.6.26 from:
> 
> Small detail: can you please use "--stat --summary -M" to generate the 
> diffstat, because you had:
> 
> >  ...
> >  21 files changed, 614 insertions(+), 499 deletions(-)
> 
> but what I then check against notices the rename, and becomes:
> 
>  ...
>  20 files changed, 276 insertions(+), 161 deletions(-)
>  rename fs/{gfs2/locking => }/dlm/plock.c (67%)
>  create mode 100644 include/linux/dlm_plock.h
>  delete mode 100644 include/linux/lock_dlm_plock.h
> 
> which I think is more accurate as to how big the changes were, as well as 
> just more human-readable and informative.
> 
> (Apparently the naming changes in lock_dlm_plock.h -> dlm_plock.h makes it 
> be effectively a rewrite, explaining why it's not two renames..)

Yep, will do.  Nice diffstat for the record,

 fs/dlm/Makefile                   |    1 +
 fs/dlm/config.c                   |   50 +++++++++--
 fs/dlm/config.h                   |    3 +-
 fs/dlm/dlm_internal.h             |    8 +-
 fs/dlm/lock.c                     |    5 +-
 fs/dlm/lock.h                     |    1 -
 fs/dlm/main.c                     |    7 ++
 fs/dlm/member.c                   |   34 +++++++-
 fs/{gfs2/locking => }/dlm/plock.c |  169 ++++++++++++++++++++++---------------
 fs/dlm/recoverd.c                 |    1 +
 fs/gfs2/locking/dlm/Makefile      |    2 +-
 fs/gfs2/locking/dlm/lock_dlm.h    |   12 +---
 fs/gfs2/locking/dlm/main.c        |    8 --
 fs/gfs2/locking/dlm/mount.c       |   21 +++++
 include/linux/Kbuild              |    2 +-
 include/linux/dlm.h               |    7 +-
 include/linux/dlm_device.h        |   11 ++-
 include/linux/dlm_plock.h         |   50 +++++++++++
 include/linux/dlmconstants.h      |    4 +
 include/linux/lock_dlm_plock.h    |   41 ---------
 20 files changed, 276 insertions(+), 161 deletions(-)
 rename fs/{gfs2/locking => }/dlm/plock.c (67%)
 create mode 100644 include/linux/dlm_plock.h
 delete mode 100644 include/linux/lock_dlm_plock.h

