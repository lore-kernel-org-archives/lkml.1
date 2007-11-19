Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbXKSTSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbXKSTSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbXKSTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:17:54 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43285 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbXKSTRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:17:53 -0500
Date: Mon, 19 Nov 2007 11:17:48 -0800
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Subject: [PATCH] radix_tree.h trivial comment correction
Message-ID: <20071119191747.GA17234@tpepper-t42p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is an unmatched parenthesis in the locking commentary of radix_tree.h
which is trivially fixed by the patch below.

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>

---

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -91,7 +91,7 @@ do {									\
  *
  * For API usage, in general,
  * - any function _modifying_ the tree or tags (inserting or deleting
- *   items, setting or clearing tags must exclude other modifications, and
+ *   items, setting or clearing tags) must exclude other modifications, and
  *   exclude any functions reading the tree.
  * - any function _reading_ the tree or tags (looking up items or tags,
  *   gang lookups) must exclude modifications to the tree, but may occur
