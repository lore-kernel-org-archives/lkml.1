Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXF0SA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXF0SA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbXF0SAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:00:52 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36552 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443AbXF0SAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:00:51 -0400
Subject: [PATCH] CodingStyle: Add information about editor modelines
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, josh@kernel.org
Content-Type: text/plain
Date: Wed, 27 Jun 2007 11:00:46 -0700
Message-Id: <1182967246.8970.112.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@freedesktop.org>
---
I recently received a patch including a file that had a vim modeline,
and I realized that nothing specifically proscribed that practice.

 Documentation/CodingStyle |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 00bffa7..a667eb1 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -738,6 +738,33 @@ need them.  Feel free to peruse that header file to see what else is already
 defined that you shouldn't reproduce in your code.
 

+		Chapter 18:  Editor modelines and other cruft
+
+Some editors can interpret configuration information embedded in source files,
+indicated with special markers.  For example, emacs interprets lines marked
+like this:
+
+-*- mode: c -*-
+
+Or like this:
+
+/*
+Local Variables:
+compile-command: "gcc -DMAGIC_DEBUG_FLAG foo.c"
+End:
+*/
+
+Vim interprets markers that look like this:
+
+/* vim:set sw=8 noet */
+
+Do not include any of these in source files.  People have their own personal
+editor configurations, and your source files should not override them.  This
+includes markers for indentation and mode configuration.  People may use their
+own custom mode, or may have some other magic method for making indentation
+work correctly.
+
+
 
 		Appendix I: References
 
-- 
1.5.2.1


