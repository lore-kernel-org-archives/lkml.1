Return-Path: <linux-kernel-owner+w=401wt.eu-S1762584AbZLPWOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762584AbZLPWOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760802AbZLPWOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:14:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758986AbZLPWOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:14:42 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip] x86: Fix a typo in gen-insn-attr-x86.awk
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jim Keniston <jkenisto@us.ibm.com>
Date: Wed, 16 Dec 2009 17:18:53 -0500
Message-ID: <20091216221853.14071.61224.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo of "character" in gen-insn-attr-x86.awk.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
---

 arch/x86/tools/gen-insn-attr-x86.awk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index 7a68506..6d1dc09 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -7,7 +7,7 @@
 # Awk implementation sanity check
 function check_awk_implement() {
 	if (!match("abc", "[[:lower:]]+"))
-		return "Your awk doesn't support charactor-class."
+		return "Your awk doesn't support character-class."
 	if (sprintf("%x", 0) != "0")
 		return "Your awk has a printf-format problem."
 	return ""


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
