Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZCaLzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZCaLzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 07:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbZCaLzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 07:55:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:10615 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZCaLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 07:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Zd3Rrj9fiJ9tF4LL+K6H0qgoRZ7JHs3t6oM52qNZJhSW3HhRrCDsuIQ7Y2hmbuOtYb
         h4c7TY14GnSTkt+y7o5gNglUwxO69eM2+67xzRWzaXJsWI+7/CedPU+CE9d9gCVsIHdY
         JZevb3A+5BWvkmfxUxMEK/H76NelBozMs06BQ=
Date: Tue, 31 Mar 2009 15:54:51 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH next] ext4: fix printk format warning in inode.c
Message-ID: <20090331115451.GA3475@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/ext4/inode.c:385: warning: format '%u' expects type 'unsigned int', but argument 7 has type 'long int'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 fs/ext4/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1d37d14..2fda129 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -382,7 +382,7 @@ static int __ext4_check_blockref(const char *function, struct inode *inode,
 				   "block reference %u >= max (%u) "
 				   "in inode #%lu, offset=%u",
 				   *bref, maxblocks,
-				   inode->i_ino, bref-p);
+				   inode->i_ino, (unsigned)(bref-p));
  			return -EIO;
  		}
 		bref++;
