Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXF0R72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXF0R72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758225AbXF0R7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:59:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48405 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbXF0R7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:59:20 -0400
Subject: [PATCH] CodingStyle: Add information about trailing whitespace.
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, josh@kernel.org
Content-Type: text/plain
Date: Wed, 27 Jun 2007 10:59:20 -0700
Message-Id: <1182967160.8970.108.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 Documentation/CodingStyle |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index b49b92e..00bffa7 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -218,6 +218,18 @@ no space after the prefix increment & decrement unary operators:
 
 and no space around the '.' and "->" structure member operators.
 
+Do not leave trailing whitespace at the ends of lines.  Some editors with
+"smart" indentation will insert whitespace at the beginning of new lines as
+appropriate, so you can start typing the next line of code right away.
+However, some such editors do not remove the whitespace if you end up not
+putting a line of code there, such as if you leave a blank line.  As a result,
+you end up with lines containing trailing whitespace.
+
+Git will warn you about patches that introduce trailing whitespace, and can
+optionally strip the trailing whitespace for you; however, if applying a series
+of patches, this may make later patches in the series fail by changing their
+context lines.
+
 
 		Chapter 4: Naming
 
-- 
1.5.2.1


