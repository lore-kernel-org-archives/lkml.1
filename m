Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbYJGUW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbYJGUW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYJGUWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:22:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:33970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYJGUWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:22:41 -0400
Date: Tue, 7 Oct 2008 13:22:39 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, joel.becker@oracle.com,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       tiger.yang@oracle.com
Subject: Re: [PATCH 13/39] ocfs2: Add extended attribute support
Message-ID: <20081007202239.GE26373@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1222293680-15451-1-git-send-email-mfasheh@suse.com> <1222293680-15451-14-git-send-email-mfasheh@suse.com> <20081001231209.44417bc1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001231209.44417bc1.akpm@linux-foundation.org>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:12:09PM -0700, Andrew Morton wrote:
> > On Wed, 24 Sep 2008 15:00:54 -0700 Mark Fasheh <mfasheh@suse.com> wrote:
> > +		case Opt_user_xattr:
> > +			mopt->mount_opt &= ~OCFS2_MOUNT_NOUSERXATTR;
> > +			break;
> > +		case Opt_nouser_xattr:
> > +			mopt->mount_opt |= OCFS2_MOUNT_NOUSERXATTR;
> > +			break;
> 
> Is there a documentation update for these?

There is now  :) I'm actually usually a bit of a stickler for those too, but
obviously I missed this one.
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

ocfs2: Documentation update for user_xattr / nouser_xattr mount options

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 Documentation/filesystems/ocfs2.txt |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/ocfs2.txt b/Documentation/filesystems/ocfs2.txt
index 6acf1b4..4340cc8 100644
--- a/Documentation/filesystems/ocfs2.txt
+++ b/Documentation/filesystems/ocfs2.txt
@@ -80,3 +80,5 @@ inode64			Indicates that Ocfs2 is allowed to create inodes at
 			any location in the filesystem, including those which
 			will result in inode numbers occupying more than 32
 			bits of significance.
+user_xattr	(*)	Enables Extended User Attributes.
+nouser_xattr		Disables Extended User Attributes.
-- 
1.5.4.1

