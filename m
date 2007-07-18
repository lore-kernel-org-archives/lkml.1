Return-Path: <linux-kernel-owner+w=401wt.eu-S936495AbXGRX3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936495AbXGRX3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932776AbXGRX0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:26:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:57433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936304AbXGRX0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:26:45 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Brandon Philips <bphilips@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/14] Documentation fix devres.txt: lib/iomap.c -> lib/devres.c
Date: Wed, 18 Jul 2007 16:25:42 -0700
Message-Id: <11848011731698-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <1184801169806-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
 <1184801169806-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brandon Philips <bphilips@suse.de>

Signed-off-by: Brandon Philips <bphilips@suse.de>
Acked-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/driver-model/devres.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 6c8d8f2..8569072 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -207,7 +207,7 @@ responsibility.  This is usually non-issue because bus ops and
 resource allocations already do the job.
 
 For an example of single-instance devres type, read pcim_iomap_table()
-in lib/iomap.c.
+in lib/devres.c.
 
 All devres interface functions can be called without context if the
 right gfp mask is given.
-- 
1.5.2.2

