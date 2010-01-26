Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699Ab0AZVDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab0AZVDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779Ab0AZVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:03:05 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:48403 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab0AZVDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:03:04 -0500
Message-ID: <4B5F5882.7010800@hp.com>
Date: Tue, 26 Jan 2010 16:02:58 -0500
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-doc@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] doc: document IPv6 parameters
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation to describe IPv6 parameters.
Reported by <greg@enjellic.com>.

Signed-off-by: Brian Haley <brian.haley@hp.com>
---

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 736d456..3ca7f8f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -54,6 +54,7 @@ parameter is applicable:
 	IMA     Integrity measurement architecture is enabled.
 	IOSCHED	More than one I/O scheduler is enabled.
 	IP_PNP	IP DHCP, BOOTP, or RARP is enabled.
+	IPV6	IPv6 support is enabled.
 	ISAPNP	ISA PnP code is enabled.
 	ISDN	Appropriate ISDN support is enabled.
 	JOY	Appropriate joystick support is enabled.
@@ -347,6 +348,9 @@ and is between 256 and 4096 characters. It is defined in the file
 			Change the amount of debugging information output
 			when initialising the APIC and IO-APIC components.
 
+	autoconf=	[IPV6]
+			See Documentation/networking/ipv6.txt.
+
 	show_lapic=	[APIC,X86] Advanced Programmable Interrupt Controller
 			Limit apic dumping. The parameter defines the maximal
 			number of local apics being dumped. Also it is possible
@@ -629,6 +633,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			See drivers/char/README.epca and
 			Documentation/serial/digiepca.txt.
 
+	disable=	[IPV6]
+			See Documentation/networking/ipv6.txt.
+
+	disable_ipv6=	[IPV6]
+			See Documentation/networking/ipv6.txt.
+
 	disable_mtrr_cleanup [X86]
 			The kernel tries to adjust MTRR layout from continuous
 			to discrete, to make X server driver able to add WB
