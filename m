Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838Ab0ARKxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0ARKxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 05:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162Ab0ARKxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 05:53:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0ARKxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 05:53:47 -0500
Subject: Re: linux-next: manual merge of the vfs tree with the gfs2 tree
From: Steven Whitehouse <swhiteho@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <20100118105556.230beb08.sfr@canb.auug.org.au>
References: <20100118105556.230beb08.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 18 Jan 2010 10:56:41 +0000
Message-ID: <1263812201.2715.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-01-18 at 10:55 +1100, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the vfs tree got a conflict in
> fs/gfs2/ops_inode.c between commit
> 83c77e8b3457f2ee5dad028dc54cf3ce540104b2 ("GFS2: Fix refcnt leak on
> gfs2_follow_link() error path") from the gfs2 tree and commit
> 261a144ac2b3867c7be70f08925e446430df6937 ("Switch gfs2 to nd_set_link()")
> from the vfs tree.
> 
> I can't figure out if the gfs2 tree fix is required any more, so I just
> used the vfs tree version.
> 
> Al, if that gfs2 patch is standalone, you should probably send it to the
> gfs2 guys.
> 

It looks as if the two patches would be alternatives. The only question
is whether Al's patch should be left for the merge window or whether its
ok to send it ahead of time to fix the issue (which is what I had been
intending to do with the bug fix prior to Al's patch).

Thoughts?

Steve.


