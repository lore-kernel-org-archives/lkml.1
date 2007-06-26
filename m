Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbXFZObE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbXFZObE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXFZOax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:30:53 -0400
Received: from zakalwe.fi ([80.83.5.154]:33924 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138AbXFZOaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:30:52 -0400
Date: Tue, 26 Jun 2007 17:30:46 +0300
From: Heikki Orsila <shdl@zakalwe.fi>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation: improvement to volatile considered harmful
Message-ID: <20070626143046.GA3400@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel locking/synchronization primitives are better than volatile types 
from code readability point of view also.

This patch is against 2.6.22-rc6.

Signed-off-by: Heikki Orsila <heikki.orsila@iki.fi>

diff --git a/Documentation/volatile-considered-harmful.txt b/Documentation/volatile-considered-harmful.txt
index 10c2e41..ab9e62e 100644
--- a/Documentation/volatile-considered-harmful.txt
+++ b/Documentation/volatile-considered-harmful.txt
@@ -17,8 +17,9 @@ all optimization-related problems in a more efficient way.
 
 Like volatile, the kernel primitives which make concurrent access to data
 safe (spinlocks, mutexes, memory barriers, etc.) are designed to prevent
-unwanted optimization.  If they are being used properly, there will be no
-need to use volatile as well.  If volatile is still necessary, there is
+unwanted optimization. If they are being used properly, there will be no
+need to use volatile as well. Also, they make code more readable as they
+represent their intent explicitly. If volatile is still necessary, there is
 almost certainly a bug in the code somewhere.  In properly-written kernel
 code, volatile can only serve to slow things down.
 

