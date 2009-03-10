Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZCJCTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZCJCTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbZCJCTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:19:30 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2886 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752089AbZCJCT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:19:29 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Mar 2009 22:19:29 EDT
X-BigFish: VS13(zz936eQzz10c0jzzz2dh6bh87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <49B5CA78.3080300@am.sony.com>
Date: Mon, 9 Mar 2009 19:03:36 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: jason.wessel@windriver.com
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: [PATCH] kgdb: documentation
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2009 02:03:36.0807 (UTC) FILETIME=[6C812F70:01C9A124]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


gdb command "set remote debug 1" is not valid, change to correct command.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

--- linux-2.6/Documentation/DocBook/kgdb.tmpl	2009-02-05 08:10:25.000000000 -0800
+++ linux-2.6.new/Documentation/DocBook/kgdb.tmpl	2009-03-09 16:41:28.000000000 -0700
@@ -281,7 +281,7 @@
     seriously wrong while debugging, it will most often be the case
     that you want to enable gdb to be verbose about its target
     communications.  You do this prior to issuing the <constant>target
-    remote</constant> command by typing in: <constant>set remote debug 1</constant>
+    remote</constant> command by typing in: <constant>set debug remote 1</constant>
     </para>
   </chapter>
   <chapter id="KGDBTestSuite">

