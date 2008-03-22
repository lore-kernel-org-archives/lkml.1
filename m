Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbYCVXLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbYCVXLn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYCVXLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:11:34 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:29479 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbYCVXLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bDP/LC/vfS1+CypAyRTRvUsvCTE8/s8xe+iLmUu78rfZxTsT2a4eDiINtZcJJwhKc4ktYLvjJMrqGqmifVDdU8V8uiurPiwhymmalgqcvfUoNz5B1Y6i7Cq9LT8YAyNd59XhnkU4r4BVCTzci4hVMHA7FLzXo37Ru/fueKQFhrg=
Message-ID: <524f69650803221611y62967b20g4e15a7f73b03a565@mail.gmail.com>
Date: Sat, 22 Mar 2008 18:11:31 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT] CIFS Fixes
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Q (Igor Mammedov)" <qwerty0987654321@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
Please pull.

The following changes since commit dba92d3bc49c036056a48661d2d8fefe4c78375a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Harvey Harrison (1):
      [CIFS] cifs: replace remaining __FUNCTION__ occurrences

Igor Mammedov (1):
      [CIFS]  DFS patch that connects inode with dfs handling ops

Steve French (6):
      Merge branch 'master' of /.../torvalds/linux-2.6
      [CIFS] Fix build problem
      [CIFS] Fix mtime on cp -p when file data cached but written out too late
      Merge branch 'master' of /.../torvalds/linux-2.6
      [CIFS] file create with acl support enabled is slow
      [CIFS] Fix mem leak on dfs referral

 fs/cifs/cifs_dfs_ref.c |   18 +++---
 fs/cifs/cifsacl.c      |   25 +++++---
 fs/cifs/cifsproto.h    |    9 ++-
 fs/cifs/dir.c          |    5 +-
 fs/cifs/dns_resolve.c  |    8 +-
 fs/cifs/file.c         |    4 +-
 fs/cifs/inode.c        |  161 +++++++++++++++++++++++++++---------------------
 fs/cifs/link.c         |    2 +-
 8 files changed, 130 insertions(+), 102 deletions(-)

-- 
Thanks,

Steve
