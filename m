Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbXETIQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbXETIQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 04:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbXETIPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 04:15:47 -0400
Received: from fed1rmmtao106.cox.net ([68.230.241.40]:50055 "EHLO
	fed1rmmtao106.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757443AbXETIPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 04:15:45 -0400
From: Junio C Hamano <junkio@cox.net>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] Fix duplicated entry in Documentation/HOWTO
References: <f24d23310705180354l2995a89fhb513fe3e54221784@mail.gmail.com>
	<20070518131749.GA4833@kroah.com>
cc: linux-kernel@vger.kernel.org, debian developer <debiandev@gmail.com>
Date: Sun, 20 May 2007 01:15:43 -0700
In-Reply-To: <20070518131749.GA4833@kroah.com> (Greg KH's message of "Fri, 18
	May 2007 06:17:49 -0700")
Message-ID: <7v1whbsyfk.fsf_-_@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3f271008 introduced this section to Linus tree, but a
later commit 722385f7 accepted almost the identical patch via
Greg's tree, both from the same author.

This kills the duplicated one.

Signed-off-by: Junio C Hamano <junkio@cox.net>
---
 Documentation/HOWTO |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/Documentation/HOWTO b/Documentation/HOWTO
index 48123db..ced9207 100644
--- a/Documentation/HOWTO
+++ b/Documentation/HOWTO
@@ -396,26 +396,6 @@ bugme-janitor mailing list (every change in the bugzilla is mailed here)
 
 
 
-Managing bug reports
---------------------
-
-One of the best ways to put into practice your hacking skills is by fixing
-bugs reported by other people. Not only you will help to make the kernel
-more stable, you'll learn to fix real world problems and you will improve
-your skills, and other developers will be aware of your presence. Fixing
-bugs is one of the best ways to get merits among other developers, because
-not many people like wasting time fixing other people's bugs.
-
-To work in the already reported bug reports, go to http://bugzilla.kernel.org.
-If you want to be advised of the future bug reports, you can subscribe to the
-bugme-new mailing list (only new bug reports are mailed here) or to the
-bugme-janitor mailing list (every change in the bugzilla is mailed here)
-
-	http://lists.osdl.org/mailman/listinfo/bugme-new
-	http://lists.osdl.org/mailman/listinfo/bugme-janitors
-
-
-
 Mailing lists
 -------------
 

