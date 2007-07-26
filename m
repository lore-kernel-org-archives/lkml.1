Return-Path: <linux-kernel-owner+w=401wt.eu-S936082AbXGZVgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936082AbXGZVgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765626AbXGZVgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:36:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41460 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764507AbXGZVgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:36:39 -0400
Subject: [PATCH] CodingStyle: proscribe do-while without braces.
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org
Content-Type: text/plain
Date: Thu, 26 Jul 2007 14:37:02 -0700
Message-Id: <1185485822.4459.1.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse warns about do-while loops without braces; Linus's rationale from the
Sparse Git changelog:
> Add warning message for naked do-while
>
> Does it necessarily make sense? Dunno, but it does tend to be bad
> practice, or at least result in code that can be hard to mentally parse.
>
> Maybe that mental parsing is just me.	 Or maybe it should be warned
> about. You decide.

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 Documentation/CodingStyle |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 7f1730f..f12e4b8 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -175,6 +175,13 @@ if (condition) {
 	otherwise();
 }
 
+This also does not apply to a do-while loop; always use braces with a do-while,
+even if it contains a single statement:
+
+do {
+	this();
+} while(condition);
+
 		3.1:  Spaces
 
 Linux kernel style for use of spaces depends (mostly) on
-- 
1.5.2.1


