Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbZGTUSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbZGTUSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:18:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZGTUSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:18:12 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:16408 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZGTUSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O1cSP2T8hllXI2Q5kcWYANvwSwXGVIYOJ6QZ77795wwlAgAsNkJCd4MdnrzfFa2YRe
         XE5qVJw/DlobTzbgc7vTN8OcJeW/JFzlRqoNhtn2UYlLHhmujOuQgOIH2xHQ9GQMk7GE
         /w5ZKdi0MDp/v7dm5NMQ6IfJknOG7xSIpxr3U=
MIME-Version: 1.0
Date: Mon, 20 Jul 2009 15:18:11 -0500
Message-ID: <a4e6962a0907201318v4735b8cfo62e182826ad50eb0@mail.gmail.com>
Subject: [git pull] 9p-fixes for 2.6.31-rc
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
   Please pull these bug fixes mainline at your convenience.  Thanks.

The following changes since commit 4b0a84043e0c14088958fddb62f416d050368011:
  Linus Torvalds (1):
        Merge branch 'sched-fixes-for-linus' of
git://git.kernel.org/.../peterz/linux-2.6-sched

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Abhishek Kulkarni (3):
      9p: default 9p transport module fix
      9p: Possible regression in p9_client_stat
      9p: Fix incorrect parameters to v9fs_file_readn.

 fs/9p/vfs_addr.c |    2 +-
 net/9p/client.c  |   13 +++++--------
 2 files changed, 6 insertions(+), 9 deletions(-)
