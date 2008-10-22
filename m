Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYJVWFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYJVWFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYJVWFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:05:08 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:7795 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbYJVWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=JVbOlo07xbCAtCGwminPGplDv0FvINaz6VWogi4NVc4Bmuo+HeDQzqfXjW7aSZPCLT
         Q9EOMnqex43/PmJZKSZ+VYG1YRPDvaSAtGpl0XKt5uZt0rwSio95vnGodnOLkaySm3og
         5tyStTZMYPwMS88Mbr2VkDfZNBsqjiyRxWg00=
Message-ID: <a4e6962a0810221505u9cd7e22k2007fb134c345e07@mail.gmail.com>
Date: Wed, 22 Oct 2008 17:05:06 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [GIT PULL] Additional 9p patches for 2.6.28 merge window
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4:
  Paul Mundt (1):
        binfmt_elf_fdpic: Update for cputime changes.

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Eric Van Hensbergen (3):
      9p: fix debug build error
      9p: fix format warning
      9p: fix sparse warnings

Tom Tucker (1):
      9p: rdma: RDMA Transport Support for 9P

 fs/9p/vfs_file.c        |    3 +-
 include/net/9p/9p.h     |    2 +-
 include/net/9p/client.h |    2 +
 net/9p/Kconfig          |    6 +
 net/9p/Makefile         |    4 +
 net/9p/client.c         |    1 +
 net/9p/protocol.c       |   33 ++-
 net/9p/trans_fd.c       |    4 +-
 net/9p/trans_rdma.c     |  712 +++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 750 insertions(+), 17 deletions(-)
 create mode 100644 net/9p/trans_rdma.c

    Thanks,
           -eric
