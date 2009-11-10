Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbZKJTzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbZKJTzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757925AbZKJTzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:55:45 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35013 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912AbZKJTzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:55:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=nXhsKwPpyhQZNY0nhVRl6CVtSPPJRReVW+t67HhYM0Auh8sLWgE8cRm+BO2iF2818Q
         MCdbnUiJGAxGS++1frhyGnzss6FVWQvrXmz3ueaSd1p8qmwegldv7wJCt7n4zR+sv4yD
         kpmP5T9ibzXxdJHs7/4DhI9JBt+MZsSMz+TOg=
Message-ID: <4AF9C540.5090403@gmail.com>
Date: Tue, 10 Nov 2009 14:55:44 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH resent] Documentation: rw_lock lessons learned
Content-Type: multipart/mixed;
 boundary="------------040700040300000504090809"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040700040300000504090809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In recent weeks, two different network projects erroneously
strayed down the rw_lock path.  Update the Documentation
based upon comments in those threads.

Signed-off-by: William.Allen.Simpson@gmail.com
---
   Documentation/spinlocks.txt |   14 ++++++++++++++
   1 files changed, 14 insertions(+), 0 deletions(-)


--------------040700040300000504090809
Content-Type: text/plain; x-mac-type="54455854"; x-mac-creator="0";
 name="spinlocks.txt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="spinlocks.txt.patch"

diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
index 619699d..c112052 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/spinlocks.txt
@@ -233,4 +233,18 @@ indeed), while write-locks need to protect themselves against interrupts.
 
 		Linus
 
+----
+
+The implications of spin_locks on memory are further described in:
+
+  Documentation/memory-barriers.txt
+    (5) LOCK operations.
+    (6) UNLOCK operations.
+
+----
+
+We are working hard to remove reader-writer spinlocks (rw_lock) from the
+network stack, so please don't add a new one.  Instead, see:
+
+  Documentation/RCU/rcu.txt
 
-- 
1.6.3.3



--------------040700040300000504090809--
