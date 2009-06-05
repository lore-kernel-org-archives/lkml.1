Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZFEXsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZFEXsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZFEXl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:57 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36419 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZFEXlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:12 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: David VomLehn <dvomlehn@cisco.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 21/39] kbuild/Documentation: Incorrect makefile syntax in example
Date: Sat,  6 Jun 2009 01:42:39 +0200
Message-Id: <1244245377-17441-21-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David VomLehn <dvomlehn@cisco.com>

There is an error in the make syntax for one of the kbuild examples

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Documentation/kbuild/modules.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/kbuild/modules.txt b/Documentation/kbuild/modules.txt
index b1096da..0767cf6 100644
--- a/Documentation/kbuild/modules.txt
+++ b/Documentation/kbuild/modules.txt
@@ -275,7 +275,7 @@ following files:
 
 		KERNELDIR := /lib/modules/`uname -r`/build
 		all::
-			$(MAKE) -C $KERNELDIR M=`pwd` $@
+			$(MAKE) -C $(KERNELDIR) M=`pwd` $@
 
 		# Module specific targets
 		genbin:
-- 
1.6.3.rc3.40.g75b44

