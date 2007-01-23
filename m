Return-Path: <linux-kernel-owner+w=401wt.eu-S932250AbXAWFcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250AbXAWFcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933002AbXAWFcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:32:04 -0500
Received: from havoc.gtf.org ([69.61.125.42]:42523 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250AbXAWFcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:32:03 -0500
Date: Tue, 23 Jan 2007 00:32:00 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] mention JFFS impending death
Message-ID: <20070123053200.GA19531@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


JFFS is already marked CONFIG_BROKEN in fs/Kconfig, with a note that
it's going away in 2.6.21, but the corresponding update to
feature-removal-schedule.txt was accidentally omitted.  Fixed.

Please pull from 'kill-jffs-prep' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git kill-jffs-prep

to receive the following updates:

 Documentation/feature-removal-schedule.txt |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

Jeff Garzik (1):
      Note that JFFS (v1) is to be deleted, in feature-removal-schedule.txt

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index fc53239..0ba6af0 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -318,3 +318,10 @@ Why:	/proc/acpi/button has been replaced by events to the input layer
 Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
+
+What:	JFFS (version 1)
+When:	2.6.21
+Why:	Unmaintained for years, superceded by JFFS2 for years.
+Who:	Jeff Garzik <jeff@garzik.org>
+
+---------------------------
