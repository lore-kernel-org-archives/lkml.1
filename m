Return-Path: <linux-kernel-owner+w=401wt.eu-S934777AbXJOUPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934777AbXJOUPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933312AbXJOUPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:15:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37939 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752982AbXJOUPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:15:39 -0400
Date: Mon, 15 Oct 2007 21:19:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] geode lists are subscriber only
Message-ID: <20071015211941.271cb0ee@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This gave me bounces and moans when chasing CS5536 so document it

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --exclude-from /usr/src/exclude --new-file --recursive linux.vanilla-2.6.23-mm1/MAINTAINERS linux-2.6.23-mm1/MAINTAINERS
--- linux.vanilla-2.6.23-mm1/MAINTAINERS	2007-10-15 15:03:24.000000000 +0100
+++ linux-2.6.23-mm1/MAINTAINERS	2007-10-15 15:28:55.000000000 +0100
@@ -353,13 +353,12 @@
 AMD GEODE CS5536 USB DEVICE CONTROLLER DRIVER
 P:	Thomas Dahlmann
 M:	thomas.dahlmann@amd.com
-L:	info-linux@geode.amd.com
+L:	info-linux@geode.amd.com	(subscribers-only)
 S:	Supported
 
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
-M:	info-linux@geode.amd.com
-L:	info-linux@geode.amd.com
+L:	info-linux@geode.amd.com	(subscribers-only)
 W:	http://www.amd.com/us-en/ConnectivitySolutions/TechnicalResources/0,,50_2334_2452_11363,00.html
 S:	Supported
 
