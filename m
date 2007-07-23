Return-Path: <linux-kernel-owner+w=401wt.eu-S1761934AbXGWRct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761934AbXGWRct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbXGWRck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:32:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbXGWRcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:32:39 -0400
Message-ID: <46A4E635.5010006@redhat.com>
Date: Mon, 23 Jul 2007 13:32:37 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch] AGP: document boot options
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation for AGP boot options.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---
 Documentation/kernel-parameters.txt |    7 +++++++
 1 file changed, 7 insertions(+)

--- 2.6.22-git11-d390.orig/Documentation/kernel-parameters.txt
+++ 2.6.22-git11-d390/Documentation/kernel-parameters.txt
@@ -30,6 +30,7 @@ the beginning of each description states
 parameter is applicable:
 
 	ACPI	ACPI support is enabled.
+	AGP	AGP (Accelerated Graphics Port) is enabled.
 	ALSA	ALSA sound support is enabled.
 	APIC	APIC support is enabled.
 	APM	Advanced Power Management support is enabled.
@@ -227,6 +228,12 @@ and is between 256 and 4096 characters. 
 			to assume that this machine's pmtimer latches its value
 			and always returns good values.
 
+	agp=		[AGP]
+			{ off | try_unsupported }
+			off: disable AGP support
+			try_unsupported: try to drive unsupported chipsets
+				(may crash computer or cause data corruption)
+
 	enable_timer_pin_1 [i386,x86-64]
 			Enable PIN 1 of APIC timer
 			Can be useful to work around chipset bugs
