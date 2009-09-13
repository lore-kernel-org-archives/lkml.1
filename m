Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZIMUY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZIMUY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 16:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZIMUY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 16:24:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62793 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZIMUY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 16:24:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H//MN3IX+MZOKilYNkAKvpmqjJeSr71foEvfjCL6Ze0kqfojnZ1f8xBwnYj3Rz5VmW
         Y8yZ/zqsBK2L4Nj5JBuy0Fpchaj+WvXPol6qdedExZeBQPvvClxTISUiYSPMyUJU+OQm
         R/Ia/2pHhkZdNb1IR5EcGtapNdfWAnL57qI5g=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Subject: [PATCH] MAINTAINERS: omap: fix regex
Date: Sun, 13 Sep 2009 23:24:18 +0300
Message-Id: <1252873459-20794-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise 'arch/arm/*omap*/foo.c' wouldn't match

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 989ff11..17ecc49 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3679,7 +3679,7 @@ W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
 S:	Maintained
-F:	arch/arm/*omap*
+F:	arch/arm/*omap*/
 
 OMAP CLOCK FRAMEWORK SUPPORT
 M:	Paul Walmsley <paul@pwsan.com>
-- 
1.6.5.rc1

