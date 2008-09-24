Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYIXVng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYIXVng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYIXVnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:43:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:43966 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYIXVnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:43:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=R1i77c4ufdOinmBoz+9Ov8SdTO6zqrWJi7aRssR0rKxHVHgG76GdPCq7EjPWbrlmaD
         7F/8A8fDXXKKlex+bfUpG3bCg2UzMVBhAbqFxWxQAKkhoT3fTD3E4k0BwNoPfZ/yNMVj
         t4imJ9yueroO7nc+WawqXGpuYC+BtCzvHG3C4=
Message-ID: <a4e6962a0809241443y6ba1e0dcl1a4f938081214a69@mail.gmail.com>
Date: Wed, 24 Sep 2008 16:43:03 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT PULL] 9p bug fixes for 2.6.27-rc7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 72d31053f62c4bc464c2783974926969614a8649:
  Linus Torvalds (1):
        Linux 2.6.27-rc7

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Eric Van Hensbergen (1):
      9p: fix put_data error handling

Julia Lawall (1):
      9p: introduce missing kfree

Julien Brunel (1):
      9p: use an IS_ERR test rather than a NULL test

Tejun Heo (5):
      9p: implement proper trans module refcounting and unregistration
      9p-trans_fd: fix trans_fd::p9_conn_destroy()
      9p-trans_fd: clean up p9_conn_create()
      9p-trans_fd: don't do fs segment mangling in p9_fd_poll()
      9p-trans_fd: fix and clean up module init/exit paths

 fs/9p/vfs_inode.c          |    3 +-
 include/net/9p/9p.h        |    1 +
 include/net/9p/transport.h |    9 +++-
 net/9p/client.c            |   10 +++-
 net/9p/conv.c              |    6 ++-
 net/9p/mod.c               |   92 ++++++++++++++++++++++++++++-----------
 net/9p/trans_fd.c          |  104 +++++++++++++++----------------------------
 net/9p/trans_virtio.c      |    2 +
 8 files changed, 127 insertions(+), 100 deletions(-)
