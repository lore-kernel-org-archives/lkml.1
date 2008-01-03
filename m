Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbYACQ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbYACQ2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYACQ2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:28:25 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:49476 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYACQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:28:24 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jan 2008 11:28:24 EST
X-SBRS: None
X-MesageID: 36239785
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.24,240,1196658000"; 
   d="scan'208";a="36239785"
Date: Thu, 3 Jan 2008 16:17:54 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, torvalds@osdl.org
Subject: [PATCH][DOC] Console is utf-8 by default
Message-ID: <20080103161754.GD4305@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The console is now by default in UTF-8 mode.
Also fix the needed "vt." prefix.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

---
This documentation fix really deserves going into 2.6.24, else we'll
probably get a lot of bug reports like
http://bugzilla.kernel.org/show_bug.cgi?id=9319
(not that we won't have any...). Maybe that should even be announced in
a more highlighted place?

--- Documentation/kernel-parameters.txt	2007-12-23 22:56:31.000000000 +0100
+++ Documentation/kernel-parameters.txt	2007-12-26 00:01:44.000000000 +0100
@@ -527,29 +527,30 @@
 			Format: <area>[,<node>]
 			See also Documentation/networking/decnet.txt.
 
-	default_blu=	[VT]
+	vt.default_blu=	[VT]
 			Format: <blue0>,<blue1>,<blue2>,...,<blue15>
 			Change the default blue palette of the console.
 			This is a 16-member array composed of values
 			ranging from 0-255.
 
-	default_grn=	[VT]
+	vt.default_grn=	[VT]
 			Format: <green0>,<green1>,<green2>,...,<green15>
 			Change the default green palette of the console.
 			This is a 16-member array composed of values
 			ranging from 0-255.
 
-	default_red=	[VT]
+	vt.default_red=	[VT]
 			Format: <red0>,<red1>,<red2>,...,<red15>
 			Change the default red palette of the console.
 			This is a 16-member array composed of values
 			ranging from 0-255.
 
-	default_utf8=   [VT]
+	vt.default_utf8=
+			[VT]
 			Format=<0|1>
 			Set system-wide default UTF-8 mode for all tty's.
-			Default is 0 and by setting to 1, it enables UTF-8
-			mode for all newly opened or allocated terminals.
+			Default is 1, i.e. UTF-8 mode is enabled for all
+			newly opened terminals.
 
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
