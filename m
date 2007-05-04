Return-Path: <linux-kernel-owner+w=401wt.eu-S1767588AbXEDH1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767588AbXEDH1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 03:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767596AbXEDH1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 03:27:09 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:46506 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767588AbXEDH1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 03:27:08 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-kernel@vger.kernel.org
Subject: [patch]clarification of coding style regarding conditional statements with two branches
Date: Fri, 4 May 2007 09:26:55 +0200
User-Agent: KMail/1.9.1
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705040926.55257.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I suggest that the coding style should state that if either branch of
an 'if' statement needs braces, both branches should use them.

	Regards
		Oliver
Signed-off-by: Oliver Neukum <oneukum@suse.de>
----

--- a/Documentation/CodingStyle	2007-04-20 13:08:17.000000000 +0200
+++ b/Documentation/CodingStyle	2007-04-20 13:16:14.000000000 +0200
@@ -160,6 +160,21 @@
 25-line terminal screens here), you have more empty lines to put
 comments on.
 
+Do not unnecessarily use braces where a single statement will do.
+
+if (condition)
+	action();
+
+This does not apply if one branch of a conditional statement is a single
+statement. Use braces in both branches.
+
+if (condition) {
+	do_this();
+	do_that();
+} else {
+	otherwise();
+}
+
 		3.1:  Spaces
 
 Linux kernel style for use of spaces depends (mostly) on
