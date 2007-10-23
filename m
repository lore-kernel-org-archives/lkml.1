Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXJWS77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXJWS77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 14:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbXJWS7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 14:59:52 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:49839 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbXJWS7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fnXMfiWNfcuZE64yjANY+XB+NpKpwE0KLwdioheDFLUp8oowLIiJ0pbLTbQiH2309Hyru6qiZ1cFHtRNDUN1X0bwqT0y4GMlomnj7aYx8AVOIM9JY38Hq3JYcLp/4KQZvZk71cPkFTCpSbLI4e7xwbSWMr1IhOGReO1RBZLsa94=
Message-ID: <a4e6962a0710231159o392583dfmf98b86958e18fc68@mail.gmail.com>
Date: Tue, 23 Oct 2007 13:59:50 -0500
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: torvalds@osdl.org
Subject: [GIT PULL] 9p: 2.6.24 patches (phase 2)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the 'for-linus' branch of:
 git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git/ for-linus

This tree contains the following:

Latchesar Ionkov(1):
 9p: v9fs_vfs_rename incorrect clunk order

Adrian Bunk(1):
 9p: fix memleak in fs/9p/v9fs.c

Eric Van Hensbergen(1)
 9p: add virtio transport

 Documentation/filesystems/9p.txt |    8
 fs/9p/v9fs.c                     |    1
 fs/9p/vfs_inode.c                |    4
 include/linux/virtio_9p.h        |   10 +
 net/9p/Kconfig                   |    7
 net/9p/Makefile                  |    4
 net/9p/trans_virtio.c            |  353 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 382 insertions(+), 5 deletions(-)

     Thanks,
            -eric
