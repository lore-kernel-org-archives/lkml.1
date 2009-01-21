Return-Path: <linux-kernel-owner+w=401wt.eu-S1764486AbZAULWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764486AbZAULWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756556AbZAULWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:22:33 -0500
Received: from lutt.itea.ntnu.no ([129.241.18.234]:45624 "EHLO
	lutt.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbZAULWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:22:32 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2009 06:22:32 EST
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linux Doc <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH] Ignore byproducts from latex
From: Henrik Austad <henrik@austad.us>
Date: Wed, 21 Jan 2009 12:16:15 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211216.15412.henrik@austad.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using 'make pdfdocs', auto-generated files should be ignored

Signed-off-by: Henrik Austad <henrik@austad.us>
---
 Documentation/DocBook/.gitignore |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/.gitignore 
b/Documentation/DocBook/.gitignore
index c102c02..c6def35 100644
--- a/Documentation/DocBook/.gitignore
+++ b/Documentation/DocBook/.gitignore
@@ -4,3 +4,7 @@
 *.html
 *.9.gz
 *.9
+*.aux
+*.dvi
+*.log
+*.out
-- 
1.6.1



