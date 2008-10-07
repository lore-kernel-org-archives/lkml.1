Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbYJGLWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbYJGLWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYJGLV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:21:59 -0400
Received: from ns1.suse.de ([195.135.220.2]:44098 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832AbYJGLV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:21:58 -0400
From: Bernhard Walle <bwalle@suse.de>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Document panic_on_unrecovered_nmi sysctl
Date: Tue,  7 Oct 2008 13:21:56 +0200
Message-Id: <1223378516-24304-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds "panic_on_unrecovered_nmi" sysctl to
Documentation/filesystems/proc.txt. The text is mainly taken from
http://readlist.com/lists/vger.kernel.org/linux-kernel/43/217998.html.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 Documentation/filesystems/proc.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index f566ad9..d2f77d9 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1322,6 +1322,18 @@ debugging information is displayed on console.
 NMI switch that most IA32 servers have fires unknown NMI up, for example.
 If a system hangs up, try pressing the NMI switch.
 
+panic_on_unrecovered_nmi
+------------------------
+
+The default Linux behaviour on an NMI of either memory or unknown is to continue
+operation. For many environments such as scientific computing it is preferable
+that the box is taken out and the error dealt with than an uncorrected
+parity/ECC error get propogated.
+
+A small number of systems do generate NMI's for bizarre random reasons such as
+power management so the default is off. That sysctl works like the existing
+panic controls already in that directory.
+
 nmi_watchdog
 ------------
 
-- 
1.6.0.2

