Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYGUW7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYGUW7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 18:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYGUW7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 18:59:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:14977 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbYGUW7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 18:59:05 -0400
Date: Mon, 21 Jul 2008 15:58:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] SubmittingPatches: add git pull & diffstat format info
Message-Id: <20080721155822.93be689c.randy.dunlap@oracle.com>
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

Add git pull command info and diffstat summary info so that we don't
have to search email archives for it repeatedly.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/SubmittingPatches |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- linux-2.6.26-git8.orig/Documentation/SubmittingPatches
+++ linux-2.6.26-git8/Documentation/SubmittingPatches
@@ -528,7 +528,33 @@ See more details on the proper patch for
 references.
 
 
+16) Sending "git pull" requests  (from Linus emails)
 
+Please write the git repo address and branch name alone on the same line
+so that I can't even by mistake pull from the wrong branch, and so
+that a triple-click just selects the whole thing.
+
+So the proper format is something along the lines of:
+
+	"Please pull from
+
+		git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus
+
+	 to get these changes:"
+
+so that I don't have to hunt-and-peck for the address and inevitably
+get it wrong (actually, I've only gotten it wrong a few times, and
+checking against the diffstat tells me when I get it wrong, but I'm
+just a lot more comfortable when I don't have to "look for" the right
+thing to pull, and double-check that I have the right branch-name).
+
+
+Please use "git diff -M --stat --summary" to generate the diffstat:
+the -M enables rename detection, and the summary enables a summary of
+new/deleted or renamed files.
+
+With rename detection, the statistics are rather different [...]
+because git will notice that a fair number of the changes are renames.
 
 -----------------------------------
 SECTION 2 - HINTS, TIPS, AND TRICKS
