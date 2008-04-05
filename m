Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbYDENXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbYDENXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbYDENWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:22:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:6641 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYDENWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=D+3kPr5YjOVdyK8rUpPMlItgf2MMcdgcFgQLWzwa9NmlWZCBZmVMWY2KidHSTKGQjMXUZenxy2/zyV1L1JuF34nO1Z2MdD7o6H9udNz+1gew4Le2fhtXhYr5BFrMoXZSJSRgpd1ldG+voDK58PO3Tqw7vpgTTbnukemY2BvZir0=
Message-ID: <6101e8c40804050622k18fde2f5p73c42d27a3189fe3@mail.gmail.com>
Date: Sat, 5 Apr 2008 15:22:48 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: [OP] linux v2.6.22.21-op1
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Dave Kleikamp" <shaggy@austin.ibm.com>,
       "Przemyslaw Wegrzyn" <czajnik@czajsoft.pl>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Joe Korty" <joe.korty@ccur.com>, "Neil Brown" <neilb@suse.de>,
       "Steve French" <sfrench@us.ibm.com>,
       "Suresh Jayaraman" <sjayaraman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I announced the v2.6.22.21-op1 "stable" kernel.

gitweb: http://repo.or.cz/w/linux-2.6.22.y-op.git
 git-tree: git://repo.or.cz/linux-2.6.22.y-op.git
 patches-gitweb : http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
 tar-bz2: http://students.zipernowsky.hu/~oliverp/kernel-stable/v2.6.22.21-op1.tar.bz2
 patch: http://students.zipernowsky.hu/~oliverp/kernel-stable/patch-v2.6.22.20-op1-v2.6.22.21-op1.bz2
 chlog: http://students.zipernowsky.hu/~oliverp/kernel-stable/chlog-v2.6.22.21-op1
 ======================================

 Makefile                       |    2 +-
 drivers/md/raid5.c             |   14 ++---
 drivers/net/tulip/tulip_core.c |    4 +
 fs/cifs/cifs_debug.c           |   92 +++--------------------------
 fs/cifs/cifsglob.h             |   11 ++++
 fs/cifs/cifsproto.h            |    4 +-
 fs/cifs/cifssmb.c              |  130 ++++++++++++++++++----------------------
 fs/cifs/connect.c              |    9 ++-
 fs/cifs/file.c                 |   14 ++--
 fs/cifs/sess.c                 |    3 +-
 fs/cifs/transport.c            |   88 +++++++++++++++++++++------
 mm/slab.c                      |    5 +-
 12 files changed, 174 insertions(+), 202 deletions(-)

 ======================================
gitweb: http://repo.or.cz/w/linux-2.6.22.y-op.git
 git-tree: git://repo.or.cz/linux-2.6.22.y-op.git
 patches-gitweb : http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
 tar-bz2: http://students.zipernowsky.hu/~oliverp/kernel-stable/v2.6.22.21-op1.tar.bz2
 patch: http://students.zipernowsky.hu/~oliverp/kernel-stable/patch-v2.6.22.20-op1-v2.6.22.21-op1.bz2
 chlog: http://students.zipernowsky.hu/~oliverp/kernel-stable/chlog-v2.6.22.21-op1
 ======================================

 Makefile                       |    2 +-
 drivers/md/raid5.c             |   14 ++---
 drivers/net/tulip/tulip_core.c |    4 +
 fs/cifs/cifs_debug.c           |   92 +++--------------------------
 fs/cifs/cifsglob.h             |   11 ++++
 fs/cifs/cifsproto.h            |    4 +-
 fs/cifs/cifssmb.c              |  130 ++++++++++++++++++----------------------
 fs/cifs/connect.c              |    9 ++-
 fs/cifs/file.c                 |   14 ++--
 fs/cifs/sess.c                 |    3 +-
 fs/cifs/transport.c            |   88 +++++++++++++++++++++------
 mm/slab.c                      |    5 +-
 12 files changed, 174 insertions(+), 202 deletions(-)

 ======================================

Joe Korty (1):
      slab: NUMA slab allocator migration bugfix

NeilBrown (1):
      md: fix an occasional deadlock in raid5

Oliver Pinter (1):
      v2.6.22.21-op1

Steve French (2):
      Fix buffer overflow if server sends corrupt response to small
      Fix sign mount option and sign proc config setting

andrew.patterson@hp.com (1):
      MCA when shutting down tulip quad-NIC

======================================
 Thanks,
 Oliver
 /* http://students.zipernowsky.hu/~oliverp/ */
