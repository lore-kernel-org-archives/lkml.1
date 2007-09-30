Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbXI3DP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbXI3DP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 23:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXI3DPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 23:15:18 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45946
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752522AbXI3DPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 23:15:16 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org, Ben Dooks <ben@simtec.co.uk>
Subject: [PATCH] Tweak Documentation/SM501.txt
Date: Sat, 29 Sep 2007 22:15:12 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709292215.12893.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

The existing Documentation/SM501.txt gives no clue what the chip is or does,
so copy the description from Kconfig help text.

cc: Ben Dooks <ben@simtec.co.uk>

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/SM501.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -r dc28e4e17791 Documentation/SM501.txt
--- a/Documentation/SM501.txt	Wed Sep 26 15:52:17 2007 -0700
+++ b/Documentation/SM501.txt	Sat Sep 29 14:01:43 2007 -0500
@@ -2,6 +2,11 @@
 			============
 
 Copyright 2006, 2007 Simtec Electronics
+
+The Silicon Motion SM501 multimedia companion chip is a multifunction device
+which may provide numerous interfaces including USB host controller USB gadget,
+Asyncronous Serial ports, Audio functions and a dual display video interface.
+The device may be connected by PCI or local bus with varying functions enabled.
 
 Core
 ----

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
