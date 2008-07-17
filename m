Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYGQHHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYGQHHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYGQHG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:06:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:61114 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYGQHG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:06:59 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] Fix collateral damage to top level Makefile
To: petkovbb@googlemail.com, jrigby@freescale.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       torvalds@linux-foundation.org
Date: Thu, 17 Jul 2008 01:06:55 -0600
Message-ID: <20080717070549.30755.13083.stgit@trillian.secretlab.ca>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

The patch named "powerpc/mpc5121: Add clock driver", also contained
an unrelated and bogus change to the top-level makefile.  This patch
backs out the bad bit.

SHA1 of offending patch: 137e95906e294913fab02162e8a1948ade49acb5)

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

If the maintainer who picked up this patch (Grant Likely) had done
his job, this cack-up never would have happened.  Why do we still
have to deal with such sloppy individuals?

Ben/Linus;  I assume one of you will want to pick this up soonish?
Otherwise, I'll add it to my tree and it will be part of my next
pull request.

g.

 Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 1564577..6192922 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,3 @@
-FRED=42
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 26

