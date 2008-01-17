Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYAQWtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYAQWtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759181AbYAQWhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:37:24 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11135 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760154AbYAQWhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:37:02 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Tao Ma <tao.ma@oracle.com>
Subject: [PATCH 11/30] ocfs2: Reserve ioctl range
Date: Thu, 17 Jan 2008 14:35:37 -0800
Message-Id: <1200609356-17788-12-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
References: <1200609356-17788-1-git-send-email-mark.fasheh@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

We need to reserve at least two ioctls for online-resize. Reserve a small
range of ioctls for Ocfs2 use in Documentation/ioctl-number.txt. This should
give us enough room for future growth.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 Documentation/ioctl-number.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl-number.txt b/Documentation/ioctl-number.txt
index 5c7fbf9..c18363b 100644
--- a/Documentation/ioctl-number.txt
+++ b/Documentation/ioctl-number.txt
@@ -138,6 +138,7 @@ Code	Seq#	Include File		Comments
 'm'	00-1F	net/irda/irmod.h	conflict!
 'n'	00-7F	linux/ncp_fs.h
 'n'	E0-FF	video/matrox.h          matroxfb
+'o'	00-1F	fs/ocfs2/ocfs2_fs.h	OCFS2
 'p'	00-0F	linux/phantom.h		conflict! (OpenHaptics needs this)
 'p'	00-3F	linux/mc146818rtc.h	conflict!
 'p'	40-7F	linux/nvram.h
-- 
1.5.3.6

