Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbXEUOqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbXEUOqb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 10:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXEUOqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 10:46:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbXEUOqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 10:46:23 -0400
Date: Mon, 21 May 2007 10:46:18 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rdunlap@xenotime.net
Subject: RFC: Schedule EFS for removal.
Message-ID: <20070521144618.GA6914@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, rdunlap@xenotime.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EFS aparently is broken (See http://bugzilla.kernel.org/show_bug.cgi?id=1020)
has been so for some time, and attempts to fix it have been rejected.
Given there's a userspace app to access these volumes, how
about scheduling it for removal ?

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/Documentation/feature-removal-schedule.txt~	2007-05-21 10:42:24.000000000 -0400
+++ linux-2.6/Documentation/feature-removal-schedule.txt	2007-05-21 10:44:04.000000000 -0400
@@ -346,3 +346,9 @@ Who:  Tejun Heo <htejun@gmail.com>
 
 ---------------------------
 
+What: EFS
+When: 2.6.24
+Why:  Unmaintained for some time, and also doesn't work.
+      Userspace replacement 'efslook' aparently works.
+      (See http://bugzilla.kernel.org/show_bug.cgi?id=1020)
+
-- 
http://www.codemonkey.org.uk
