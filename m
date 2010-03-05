Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0CEEhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:37:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39319 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755282Ab0CEEhB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:37:01 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ken Kawasaki <ken_kawasaki@spring.nifty.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 05 Mar 2010 04:36:54 +0000
Message-ID: <1267763815.2819.297.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/2] firmware: Correct attribution of Sierra Wireless CIS
 files
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files have nothing to do with the pcmcia-cs project and are
distributed without any clear licence.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
The only source I can find for these files is
<http://www.sierrawireless.com/resources/faq/PC_Card/AirCard555/Aircard_Linux.tar> linked from <https://sierrawireless.custhelp.com/app/answers/detail/a_id/179/kw/linux>.

David Hinds who ran the pcmcia-cs project disclaims any knowledge of
these files.

Ben.

 firmware/WHENCE |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/firmware/WHENCE b/firmware/WHENCE
index e8e550f..839a790 100644
--- a/firmware/WHENCE
+++ b/firmware/WHENCE
@@ -635,9 +635,6 @@ File: cis/MT5634ZLX.cis
       cis/RS-COM-2P.cis
       cis/COMpad2.cis
       cis/COMpad4.cis
-      cis/SW_555_SER.cis
-      cis/SW_7xx_SER.cis
-      cis/SW_8xx_SER.cis
 
 Licence: GPL
 
@@ -645,6 +642,18 @@ Originally developed by the pcmcia-cs project
 
 --------------------------------------------------------------------------
 
+Driver: SERIAL_8250_CS - Serial PCMCIA adapter
+
+File: cis/SW_555_SER.cis
+File: cis/SW_7xx_SER.cis
+File: cis/SW_8xx_SER.cis
+
+Licence: Unknown
+
+Distributed by Sierra Wireless
+
+--------------------------------------------------------------------------
+
 Driver: PCMCIA_SMC91C92 - SMC 91Cxx PCMCIA
 
 File: ositech/Xilinx7OD.bin
-- 
1.6.6.2



