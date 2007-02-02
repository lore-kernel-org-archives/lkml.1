Return-Path: <linux-kernel-owner+w=401wt.eu-S1423144AbXBBOVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423144AbXBBOVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 09:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423138AbXBBOVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 09:21:37 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:22292 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423144AbXBBOVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 09:21:36 -0500
Date: Fri, 2 Feb 2007 15:21:33 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Fix register usage description.
Message-ID: <20070202142133.GA30839@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Fix register usage description.

Fix description of register usage as pointed out by Andreas Krebbel.
Since this document is completely outdated and would need a lot of
fixing, it might be worth considering to get rid of it...

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 Documentation/s390/Debugging390.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/Documentation/s390/Debugging390.txt linux-2.6-patched/Documentation/s390/Debugging390.txt
--- linux-2.6/Documentation/s390/Debugging390.txt	2007-02-02 14:03:56.000000000 +0100
+++ linux-2.6-patched/Documentation/s390/Debugging390.txt	2007-02-02 14:04:39.000000000 +0100
@@ -480,7 +480,7 @@ r2       argument 0 / return value 0    
 r3       argument 1 / return value 1 (if long long) call-clobbered
 r4       argument 2                                 call-clobbered
 r5       argument 3                                 call-clobbered
-r6	 argument 5                                 saved
+r6	 argument 4				    saved
 r7       pointer-to arguments 5 to ...              saved      
 r8       this & that                                saved
 r9       this & that                                saved
