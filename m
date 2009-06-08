Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZFHRqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZFHRqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZFHRqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:46:16 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:51730 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZFHRqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:46:15 -0400
Date: Mon, 8 Jun 2009 19:48:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: [PATCH] ia64: unexport fpswa.h
Message-ID: <20090608174832.GA29447@uranus.ravnborg.org>
References: <1244118232.5172.26.camel@ht.satnam> <1244118476.5172.29.camel@ht.satnam> <1244118599.5172.31.camel@ht.satnam> <20090604202212.GD13892@uranus.ravnborg.org> <57C9024A16AD2D4C97DC78E552063EA3A89196D0@orsmsx505.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3A89196D0@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fpswa.h is not relevant for userspace,
so do not export it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
---
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index ccbe8ae..c7d0a71 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -2,7 +2,6 @@ include include/asm-generic/Kbuild.asm
 
 header-y += break.h
 header-y += fpu.h
-header-y += fpswa.h
 header-y += ia64regs.h
 header-y += intel_intrin.h
 header-y += perfmon_default_smpl.h
