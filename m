Return-Path: <linux-kernel-owner+w=401wt.eu-S1758904AbZCWSFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904AbZCWSFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbZCWSE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:04:27 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:35000
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757519AbZCWSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:04:25 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 03/11] xen: export ioctl headers to userspace
Date: Mon, 23 Mar 2009 10:55:03 -0700
Message-Id: <1237830911-6249-4-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/Kbuild     |    1 +
 include/xen/Kbuild |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 include/xen/Kbuild

diff --git a/include/Kbuild b/include/Kbuild
index d8c3e3c..fe36acc 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -8,3 +8,4 @@ header-y += mtd/
 header-y += rdma/
 header-y += video/
 header-y += drm/
+header-y += xen/
diff --git a/include/xen/Kbuild b/include/xen/Kbuild
new file mode 100644
index 0000000..4e65c16
--- /dev/null
+++ b/include/xen/Kbuild
@@ -0,0 +1 @@
+header-y += evtchn.h
-- 
1.6.0.6

