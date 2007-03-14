Return-Path: <linux-kernel-owner+w=401wt.eu-S933850AbXCNFRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850AbXCNFRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXCNFM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:27 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:63770 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858AbXCNFMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:22 -0400
Message-Id: <20070314051049.972566623@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 14/18] rm include pointer to i386 msr-on-cpu.c file
Content-Disposition: inline; filename=lib-rm-msr-on-cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the C file with just the include that points to the
i386 msr-on-cpu.c file.


Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86_64/lib/msr-on-cpu.c b/arch/x86_64/lib/msr-on-cpu.c
deleted file mode 100644
index 47e0ec4..0000000
--- a/arch/x86_64/lib/msr-on-cpu.c
+++ /dev/null
@@ -1 +0,0 @@
-#include "../../i386/lib/msr-on-cpu.c"

--
