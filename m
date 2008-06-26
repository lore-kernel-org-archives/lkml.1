Return-Path: <linux-kernel-owner+w=401wt.eu-S1761737AbYFZNND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761737AbYFZNND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764714AbYFZNH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:07:28 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:23937 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764709AbYFZNHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:07:25 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 54/60] microblaze_v4: Kbuild file
Date: Thu, 26 Jun 2008 14:30:23 +0200
Message-Id: <1214483429-32360-55-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-54-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
 <1214483429-32360-37-git-send-email-monstr@seznam.cz>
 <1214483429-32360-38-git-send-email-monstr@seznam.cz>
 <1214483429-32360-39-git-send-email-monstr@seznam.cz>
 <1214483429-32360-40-git-send-email-monstr@seznam.cz>
 <1214483429-32360-41-git-send-email-monstr@seznam.cz>
 <1214483429-32360-42-git-send-email-monstr@seznam.cz>
 <1214483429-32360-43-git-send-email-monstr@seznam.cz>
 <1214483429-32360-44-git-send-email-monstr@seznam.cz>
 <1214483429-32360-45-git-send-email-monstr@seznam.cz>
 <1214483429-32360-46-git-send-email-monstr@seznam.cz>
 <1214483429-32360-47-git-send-email-monstr@seznam.cz>
 <1214483429-32360-48-git-send-email-monstr@seznam.cz>
 <1214483429-32360-49-git-send-email-monstr@seznam.cz>
 <1214483429-32360-50-git-send-email-monstr@seznam.cz>
 <1214483429-32360-51-git-send-email-monstr@seznam.cz>
 <1214483429-32360-52-git-send-email-monstr@seznam.cz>
 <1214483429-32360-53-git-send-email-monstr@seznam.cz>
 <1214483429-32360-54-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/Kbuild |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/Kbuild

diff --git a/include/asm-microblaze/Kbuild b/include/asm-microblaze/Kbuild
new file mode 100644
index 0000000..783296d
--- /dev/null
+++ b/include/asm-microblaze/Kbuild
@@ -0,0 +1,24 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += auxvec.h
+header-y += cpuinfo.h
+header-y += errno.h
+header-y += fcntl.h
+header-y += ioctl.h
+header-y += ioctls.h
+header-y += ipcbuf.h
+header-y += linkage.h
+header-y += mman.h
+header-y += msgbuf.h
+header-y += poll.h
+header-y += resource.h
+header-y += sembuf.h
+header-y += shmbuf.h
+header-y += sigcontext.h
+header-y += siginfo.h
+header-y += socket.h
+header-y += sockios.h
+header-y += statfs.h
+header-y += stat.h
+header-y += termbits.h
+header-y += ucontext.h
-- 
1.5.4.GIT

