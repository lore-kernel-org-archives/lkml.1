Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbXIOROH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbXIOROH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 13:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXIORN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 13:13:57 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45920 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbXIORN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 13:13:56 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 15 Sep 2007 19:13:29 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] x86_64: configure HPET_EMULATE_RTC automatically
To: Andi Kleen <andi@firstfloor.org>
cc: Paul Rolland <rol@as2917.net>, Vojtech Pavlik <vojtech@suse.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070915162102.GA13264@one.firstfloor.org>
Message-ID: <tkrat.910599eea91d5ea5@s5r6.in-berlin.de>
References: <1189371621.3526.28.camel@localhost.localdomain>
 <20070909210329.GE25798@one.firstfloor.org> <46E46190.6080607@garzik.org>
 <20070912224655.GC3563@stusta.de> <46EAA08F.30703@s5r6.in-berlin.de>
 <20070914151522.GL3563@stusta.de>
 <20070915080448.37457dcf@tux.DEF.witbe.net>
 <46EB9703.70705@s5r6.in-berlin.de>
 <20070915130010.4272403c@tux.DEF.witbe.net>
 <46EBFF5C.8090605@s5r6.in-berlin.de>
 <20070915162102.GA13264@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know exactly what this option does...
Andi says it should be automatic rather than exposed as a prompt.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -469,8 +469,9 @@ config HPET_TIMER
 	  <http://www.intel.com/hardwaredesign/hpetspec.htm>.
 
 config HPET_EMULATE_RTC
-	bool "Provide RTC interrupt"
+	bool
 	depends on HPET_TIMER && RTC=y
+	default y
 
 # Mark as embedded because too many people got it wrong.
 # The code disables itself when not needed.

-- 
Stefan Richter
-=====-=-=== =--= -====
http://arcgraph.de/sr/

