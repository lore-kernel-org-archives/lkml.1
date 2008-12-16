Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYLPRDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYLPRDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYLPRDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:03:31 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40928 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbYLPRDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:03:31 -0500
Subject: Re: [PATCH 0/8, v3] ensure symlinks are NUL-terminated
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Evgeniy Dushistov <dushistov@mail.ru>
In-Reply-To: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
References: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
Content-Type: text/plain
Date: Tue, 16 Dec 2008 11:03:27 -0600
Message-Id: <1229447007.3751.1.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-16 at 15:51 +0000, Duane Griffin wrote:
> These patches fix potential bugs associated with link target handling by
> NUL-terminating names read from disk.
> 
> This is version 3 of these patches. It fixes the bug, pointed out by Al Viro
> and Evgeniy Dushistov, that i_size was not being validated. In order to
> facilitate this it introduces a helper function for terminating the link name,
> as suggested by Al.

Duane,
I see you left out jfs, so I'm assuming you're letting me handle that
one.  I've push my patch upstream, so it should show up in the -next
tree.

Shaggy

> diffstat:
>  fs/ext2/inode.c          |    7 +++++--
>  fs/ext3/inode.c          |    7 +++++--
>  fs/ext4/inode.c          |    7 +++++--
>  fs/freevxfs/vxfs_inode.c |    4 +++-
>  fs/namei.c               |    7 +++++--
>  fs/sysv/inode.c          |    6 +++++-
>  fs/ufs/inode.c           |    8 ++++++--
>  include/linux/namei.h    |    5 +++++
>  8 files changed, 39 insertions(+), 12 deletions(-)
-- 
David Kleikamp
IBM Linux Technology Center

