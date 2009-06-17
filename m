Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbZFQSi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbZFQSi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760564AbZFQSiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:38:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760420AbZFQSiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:50 -0400
Date: Wed, 17 Jun 2009 14:38:51 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: fengguang.wu@intel.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] slqbinfo doesn't exist...
Message-ID: <20090617183851.GA15429@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Commit 35efa5e993a7a00a50b87d2b7725c3eafc80b083 which added a page-types
tool introduced a reference to slqbinfo in the Makefile, which, doesn't
exist... This is currently causing my rawhide builds to fail.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

---

diff --git a/Documentation/vm/Makefile b/Documentation/vm/Makefile
index 27479d4..5bd269b 100644
--- a/Documentation/vm/Makefile
+++ b/Documentation/vm/Makefile
@@ -2,7 +2,7 @@
 obj- := dummy.o
 
 # List of programs to build
-hostprogs-y := slabinfo slqbinfo page-types
+hostprogs-y := slabinfo page-types
 
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
