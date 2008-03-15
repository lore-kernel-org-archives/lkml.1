Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYCOXhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYCOXhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 19:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYCOXhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 19:37:13 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:40947 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYCOXhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 19:37:12 -0400
Date: Sat, 15 Mar 2008 16:36:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: more [PATCH 0/2] PM: Remove legacy PM
Message-Id: <20080315163602.1b368275.randy.dunlap@oracle.com>
In-Reply-To: <200803140000.02420.lenb@kernel.org>
References: <200803132351.19794.rjw@sisk.pl>
	<200803140000.02420.lenb@kernel.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

On Fri, 14 Mar 2008 00:00:02 -0400 Len Brown wrote:

Please add this docbook patch.

---

From: Randy Dunlap <randy.dunlap@oracle.com>

Source file was removed.  Need to remove docbook reference also.

Are there other files in kernel/power/ that should be added to the docbook?

$ power> kerndoc-search.pl --count *.c
file console.c: 0 kernel-doc blocks
file disk.c: 18 kernel-doc blocks
file main.c: 9 kernel-doc blocks
file poweroff.c: 0 kernel-doc blocks
file process.c: 2 kernel-doc blocks
file snapshot.c: 39 kernel-doc blocks
file swap.c: 10 kernel-doc blocks
file swsusp.c: 4 kernel-doc blocks
file user.c: 0 kernel-doc blocks

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    5 -----
 1 file changed, 5 deletions(-)

--- mmotm-2008-0314-1449.orig/Documentation/DocBook/kernel-api.tmpl
+++ mmotm-2008-0314-1449/Documentation/DocBook/kernel-api.tmpl
@@ -297,11 +297,6 @@ X!Earch/x86/kernel/mca_32.c
 !Ikernel/acct.c
   </chapter>
 
-  <chapter id="pmfuncs">
-     <title>Power Management</title>
-!Ekernel/power/pm.c
-  </chapter>
-
   <chapter id="devdrivers">
      <title>Device drivers infrastructure</title>
      <sect1><title>Device Drivers Base</title>
