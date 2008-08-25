Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYHYF3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYHYF3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 01:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbYHYF3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 01:29:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59603 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYHYF3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 01:29:12 -0400
Date: Mon, 25 Aug 2008 06:29:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs fixes
Message-ID: <20080825052911.GX28946@ZenIV.linux.org.uk>
References: <20080825052533.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825052533.GW28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  arch/alpha/kernel/osf_sys.c |   19 ++++++---
>  arch/parisc/hpux/fs.c       |   30 +++++++++-----
>  drivers/misc/acer-wmi.c     |    5 --

Argh.  diffstat against the wrong version; no, nothing in this branch touches
acer-wmi.c at all.  Correct diffstat follows:

 arch/alpha/kernel/osf_sys.c |   19 ++++++---
 arch/parisc/hpux/fs.c       |   30 +++++++++-----
 fs/9p/vfs_dir.c             |    1 +
 fs/adfs/dir.c               |    1 +
 fs/affs/dir.c               |    1 +
 fs/autofs4/root.c           |    2 +
 fs/befs/linuxvfs.c          |    1 +
 fs/compat.c                 |    8 +++-
 fs/dcache.c                 |    2 +-
 fs/efs/namei.c              |    3 +-
 fs/ntfs/namei.c             |   89 +------------------------------------------
 fs/proc/generic.c           |    1 +
 fs/readdir.c                |    8 +++-
 fs/seq_file.c               |   11 ++++-
 fs/xfs/linux-2.6/xfs_file.c |    1 +
 fs/xfs/linux-2.6/xfs_iops.c |    2 +-
 include/linux/dcache.h      |    2 +-
 17 files changed, 66 insertions(+), 116 deletions(-)
