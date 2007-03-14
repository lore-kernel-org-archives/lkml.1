Return-Path: <linux-kernel-owner+w=401wt.eu-S933888AbXCNFOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbXCNFOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933863AbXCNFMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:42 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:54296 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933843AbXCNFML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:11 -0400
Message-Id: <20070314051049.628063659@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 12/18] rm include pointer to x86_64 tsc_sync.c
Content-Disposition: inline; filename=kernel-rm-tsc-sync.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the C file with just the include that points to the
x86_64 tsc_sync.c file.


Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/i386/kernel/tsc_sync.c b/arch/i386/kernel/tsc_sync.c
deleted file mode 100644
index 1242462..0000000
--- a/arch/i386/kernel/tsc_sync.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../x86_64/kernel/tsc_sync.c"

--
