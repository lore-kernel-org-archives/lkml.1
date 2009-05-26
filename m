Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZEZJQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZEZJQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 05:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbZEZJP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 05:15:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37385 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbZEZJPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 05:15:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 0/7] Blackfin fixes for 2.6.30
Date: Tue, 26 May 2009 05:15:49 -0400
Message-Id: <1243329356-12644-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for being so late, but our previous Blackfin maintainer has moved
on, so we've been working at picking up the slack.

So the stuff here for 2.6.30 is just simple build fixes, gitignore tweaks,
MAINTAINER updates, and hooking up the new pread syscalls (which was posted
a while ago already).

Mike Frysinger (7):
  bfin_mac: fix build error due to net_device_ops convert
  Blackfin: hook up preadv/pwritev syscalls
  MAINTAINERS: update Blackfin items
  MAINTAINERS: drop (subscribers-only) markings on Blackfin lists
  Blackfin: ignore generated vmlinux.lds
  Blackfin: drop unneeded asm/.gitignore
  Blackfin: fix strncmp.o build error

 MAINTAINERS                          |   18 +++++++++---------
 arch/blackfin/include/asm/.gitignore |    1 -
 arch/blackfin/include/asm/unistd.h   |    4 +++-
 arch/blackfin/kernel/.gitignore      |    1 +
 arch/blackfin/lib/strncmp.c          |    3 +--
 arch/blackfin/mach-common/entry.S    |    2 ++
 drivers/net/bfin_mac.c               |   29 ++++++++++++++---------------
 7 files changed, 30 insertions(+), 28 deletions(-)
 delete mode 100644 arch/blackfin/include/asm/.gitignore
 create mode 100644 arch/blackfin/kernel/.gitignore

