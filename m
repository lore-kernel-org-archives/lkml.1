Return-Path: <linux-kernel-owner+w=401wt.eu-S1762244AbZEBWVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762244AbZEBWVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 18:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762100AbZEBWUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 18:20:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47599 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762131AbZEBWUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 18:20:40 -0400
From: Izik Eidus <ieidus@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, aarcange@redhat.com, chrisw@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au,
       Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 5/6] ksm: build system make it compile for all archs
Date: Sun,  3 May 2009 01:16:11 +0300
Message-Id: <1241302572-4366-6-git-send-email-ieidus@redhat.com>
In-Reply-To: <1241302572-4366-5-git-send-email-ieidus@redhat.com>
References: <1241302572-4366-1-git-send-email-ieidus@redhat.com>
 <1241302572-4366-2-git-send-email-ieidus@redhat.com>
 <1241302572-4366-3-git-send-email-ieidus@redhat.com>
 <1241302572-4366-4-git-send-email-ieidus@redhat.com>
 <1241302572-4366-5-git-send-email-ieidus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The known issues with cross platform support were fixed,
so we return it back to compile on all archs.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
---
 mm/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index f59b1e4..fb8ac63 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -228,7 +228,6 @@ config MMU_NOTIFIER
 
 config KSM
 	tristate "Enable KSM for page sharing"
-	depends on X86
 	help
 	  Enable the KSM kernel module to allow page sharing of equal pages
 	  among different tasks.
-- 
1.5.6.5

