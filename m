Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYJ3FgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYJ3FgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYJ3Ffx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:35:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47117 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbYJ3Ffw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:35:52 -0400
Date: Wed, 29 Oct 2008 22:34:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/7] docs: document how to write @varargs in kernel-doc
Message-Id: <20081029223448.9ec0ea18.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add documentation on how to use kernel-doc for function parameters
that are "..." (varargs).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/kernel-doc-nano-HOWTO.txt |    5 +++++
 1 file changed, 5 insertions(+)

--- lin2628-rc2.orig/Documentation/kernel-doc-nano-HOWTO.txt
+++ lin2628-rc2/Documentation/kernel-doc-nano-HOWTO.txt
@@ -71,6 +71,11 @@ The @argument descriptions must begin on
 this opening short function description line, with no intervening
 empty comment lines.
 
+If a function parameter is "..." (varargs), it should be listed in
+kernel-doc notation as:
+ * @...: description
+
+
 Example kernel-doc data structure comment.
 
 /**
