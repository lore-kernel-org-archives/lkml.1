Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbZJBNXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbZJBNXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZJBNXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:23:05 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:39997
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757823AbZJBNXE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:23:04 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQW2I6-04-7JV-02
X-M-MSG: 
Date: Fri, 2 Oct 2009 15:23:21 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] initcalls: add early_initcall for modules
Message-ID: <20091002132321.GC28682@aftab>
References: <20090930214859.GA28638@elte.hu>
 <20090930223956.GE17712@liondog.tnic>
 <20090930230947.GA9346@elte.hu>
 <20091001141432.GA11410@aftab>
 <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
 <20091001144637.GB11410@aftab>
 <20091001150046.GA21476@elte.hu>
 <20091001152140.GC11410@aftab>
 <20091001153250.GA25885@elte.hu>
 <20091002132101.GA28682@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091002132101.GA28682@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Oct 2009 13:22:53.0221 (UTC) FILETIME=[7250ED50:01CA4363]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 52cc05f71bac10dff8a3aacf1cad16a0bf6c375b Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 1 Oct 2009 18:52:45 +0200
Subject: [PATCH 2/3] initcalls: add early_initcall for modules

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 include/linux/init.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 400adbb..ff8bde5 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -271,6 +271,7 @@ void __init parse_early_options(char *cmdline);
 #else /* MODULE */
 
 /* Don't use these in modules, but some people do... */
+#define early_initcall(fn)		module_init(fn)
 #define core_initcall(fn)		module_init(fn)
 #define postcore_initcall(fn)		module_init(fn)
 #define arch_initcall(fn)		module_init(fn)
-- 
1.6.4.3

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

