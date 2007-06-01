Return-Path: <linux-kernel-owner+w=401wt.eu-S1752795AbXFACJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbXFACJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbXFACJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:09:13 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbXFACJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:09:12 -0400
Message-Id: <200706010209.l51299kN000531@shell0.pdx.osdl.net>
Subject: [patch 1/1] document Acked-by:
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Thu, 31 May 2007 19:09:10 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Explain what we use Acked-by: for, and how it differs from Signed-off-by:
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN Documentation/SubmittingPatches~document-acked-by Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~document-acked-by
+++ a/Documentation/SubmittingPatches
@@ -328,7 +328,20 @@ now, but you can do this to mark interna
 point out some special detail about the sign-off. 
 
 
-12) The canonical patch format
+12) When to use Acked-by:
+
+The Signed-off-by: tag implies that the signer was involved in the development
+of the patch, or that he/she was in the patch's delivery path.
+
+If a person was not directly involved in the preparation or handling of a
+patch but wishes to signify and record their approval of it then they can
+arrange to have an Acked-by: line added to the patch's changelog.
+
+Acked-by: is often used by the maintainer of the affected code when that
+maintainer neither wrote, merged nor forwarded the patch themselves.
+
+
+13) The canonical patch format
 
 The canonical patch subject line is:
 
_
