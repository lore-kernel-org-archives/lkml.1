Return-Path: <linux-kernel-owner+w=401wt.eu-S965793AbXC1Wyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793AbXC1Wyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965792AbXC1Wyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:54:54 -0400
Received: from sccrmhc12.comcast.net ([63.240.77.82]:48378 "EHLO
	sccrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965790AbXC1Wyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:54:53 -0400
Date: Wed, 28 Mar 2007 14:55:14 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -rt] Fix build on MIPS
Message-ID: <20070328215514.GA20200@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Extra #endif got into atomic.h

Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

Index: linux-2.6.21-rc5/include/asm-mips/atomic.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-mips/atomic.h
+++ linux-2.6.21-rc5/include/asm-mips/atomic.h
@@ -566,7 +566,6 @@ static __inline__ long atomic64_add_retu
 		raw_local_irq_restore(flags);
 	}
 #endif
-#endif
 
 	smp_mb();
 

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net

In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertolt Brecht
