Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYIGVyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYIGVyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 17:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYIGVyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 17:54:43 -0400
Received: from gw.goop.org ([64.81.55.164]:38295 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbYIGVyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 17:54:43 -0400
Message-ID: <48C44DA1.8060402@goop.org>
Date: Sun, 07 Sep 2008 14:54:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Rafa? Mi?ecki <zajec5@gmail.com>
Subject: [PATCH 5/3] x86: fix compile error with corruption checking disabled
References: <patchbomb.1220777491@localhost> <72081a970effa1a32861.1220777494@localhost> <20080907091112.GA5574@elte.hu> <48C3A0DC.8000206@goop.org> <20080907154055.GA31025@elte.hu> <20080907155030.GA24741@elte.hu> <20080907155115.GA28495@elte.hu>
In-Reply-To: <20080907155115.GA28495@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error:
 arch/x86/mm/init_32.c: In function 'mem_init':
 arch/x86/mm/init_32.c:908: error: implicit declaration of function 'start_periodic_check_for_corruption'

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/kernel.h |    4 ++++
 1 file changed, 4 insertions(+)

===================================================================
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -257,6 +257,10 @@
 static inline void check_for_bios_corruption(void)
 {
 }
+
+static inline void start_periodic_check_for_corruption(void)
+{
+}
 #endif
 
 /* Values used for system_state */


