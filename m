Return-Path: <linux-kernel-owner+w=401wt.eu-S1752177AbZFXFWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbZFXFWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 01:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZFXFWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 01:22:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:55122 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZFXFWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 01:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,280,1243839600"; 
   d="scan'208";a="702008200"
Subject: [PATCH] io_start uses unsigned int instead of int
From: Zhang Rui <rui.zhang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 13:23:30 +0800
Message-Id: <1245821011.15520.116.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use unsigned int instead of int
http://bugzilla.kernel.org/show_bug.cgi?id=13253

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c
+++ linux-2.6/kernel/resource.c
@@ -787,7 +787,7 @@ static int __init reserve_setup(char *st
 	static struct resource reserve[MAXRESERVE];
 
 	for (;;) {
-		int io_start, io_num;
+		unsigned int io_start, io_num;
 		int x = reserved;
 
 		if (get_option (&str, &io_start) != 2)


