Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091Ab0AML4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0AML4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 06:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773Ab0AML4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 06:56:53 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:65176 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752038Ab0AML4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:56:52 -0500
Date: Wed, 13 Jan 2010 12:57:12 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       sameo@linux.intel.com
Cc: siccegge@stud.informatik.uni-erlangen.de,
       Reinhard.Tartler@informatik.uni-erlangen.de
Subject: [PATCH] typo in kernel source (DEBUGFS)
Message-ID: <20100113115712.GA7398@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	While working on this we detected a spelling error in
drivers/mfd/ab3100-otp.c which can be corrected using the attached
patch.

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

[0] http://vamos1.informatik.uni-erlangen.de/

--7JfCtLOvnd9MIVvH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-CONFIG_DEBUG_FS-wrongly-written-asl-CONFIG_DEBUGFS.patch"

>From 31f303b71011a42dcef569a5caf26ebb2eeb429e Mon Sep 17 00:00:00 2001
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Date: Wed, 13 Jan 2010 12:47:05 +0100
Subject: [PATCH] CONFIG_DEBUG_FS wrongly written asl CONFIG_DEBUGFS

Following a already fixed documentation bug this code snippet wrongly
uses CONFIG_DEBUGFS without the underscore before FS. This patch
corrects the error.
---
 drivers/mfd/ab3100-otp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
index 0499b20..a04b53c 100644
--- a/drivers/mfd/ab3100-otp.c
+++ b/drivers/mfd/ab3100-otp.c
@@ -95,7 +95,7 @@ static int __init ab3100_otp_read(struct ab3100_otp *otp)
  * This is a simple debugfs human-readable file that dumps out
  * the contents of the OTP.
  */
-#ifdef CONFIG_DEBUGFS
+#ifdef CONFIG_DEBUG_FS
 static int show_otp(struct seq_file *s, void *v)
 {
 	struct ab3100_otp *otp = s->private;
-- 
1.6.3.3


--7JfCtLOvnd9MIVvH--
