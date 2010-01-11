Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209Ab0AKOZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0AKOZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638Ab0AKOZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:25:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab0AKOZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:25:41 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 11 Jan 2010 14:24:56 +0000
Message-Id: <1263219896.14393.127.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following GFS2 bug fixes,

Steve.


The following changes since commit 74d2e4f8d79ae0c4b6ec027958d5b18058662eea:
  Linus Torvalds (1):
        Linux 2.6.33-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git master

Steven Whitehouse (4):
      GFS2: Ensure uptodate inode size when using O_APPEND
      GFS2: Fix locking bug in rename
      GFS2: Fix gfs2_xattr_acl_chmod()
      GFS2: Use MAX_LFS_FILESIZE for meta inode size

 fs/gfs2/file.c      |   38 ++++++++++++++++++++++++++++++++++++--
 fs/gfs2/meta_io.c   |    2 +-
 fs/gfs2/ops_inode.c |    6 ++++--
 fs/gfs2/xattr.c     |   21 +++++++++++----------
 4 files changed, 52 insertions(+), 15 deletions(-)


