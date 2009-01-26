Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbZAZST0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbZAZST0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 13:19:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZAZSTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 13:19:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:59762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZAZSTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 13:19:12 -0500
Message-ID: <497DFEA6.1080108@vlnb.net>
Date: Mon, 26 Jan 2009 21:19:18 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net
Subject: [PATCH][SCST]: Update of text in SCST README about barriers usage
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18ojt9HFEzvjQ81wiqBkvaeenYdj9n/B+/GfVR
 r0S1QSAddEsdPQa4rbt67eOI7pDy32xzF2tbYwl3lMWOORl5lv
 rcWXQVLLaDOyTZR98agGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates text in SCST README about barriers usage

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 README |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: scst/README
===================================================================
--- scst/README	(revision 641)
+++ scst/README	(working copy)
@@ -607,12 +607,11 @@ IMPORTANT: By default for performance re
 	   On Linux initiators for EXT3 and ReiserFS file systems the
 	   barrier protection could be turned on using "barrier=1" and
 	   "barrier=flush" mount options correspondingly. Note, that
-	   usually it turned off by default and the status of barriers
-	   usage isn't reported anywhere in the system logs as well as
-	   there is no way to know it on the mounted file system (at
-	   least no known one). Windows and, AFAIK, other UNIX'es don't
-	   need any special explicit options and do necessary barrier
-	   actions on write-back caching devices by default. Also note
+	   usually it's turned off by default (see http://lwn.net/Articles/283161).
+	   You can check if it's turn on or off by looking in /proc/mounts.
+	   Windows and, AFAIK, other UNIX'es don't need any special
+	   explicit options and do necessary barrier actions on
+	   write-back caching devices by default. Also note
 	   that on some real-life workloads write through caching might
 	   perform better, than write back one with the barrier
 	   protection turned on.

