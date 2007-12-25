Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbXLYXLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbXLYXLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXLYXLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:11:48 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:46413 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199AbXLYXLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:11:47 -0500
Date: Wed, 26 Dec 2007 00:11:44 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH][DOC] Console is utf-8 by default
Message-ID: <20071225231144.GA4061@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The console is now by default in UTF-8 mode, so let's document this.
BTW, document the needed "vt." prefix.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- Documentation/kernel-parameters.txt.orig	2007-12-26 00:01:44.000000000 +0100
+++ Documentation/kernel-parameters.txt	2007-12-23 22:56:31.000000000 +0100
@@ -527,30 +527,29 @@
 			Format: <area>[,<node>]
 			See also Documentation/networking/decnet.txt.
 
-	vt.default_blu=	[VT]
+	default_blu=	[VT]
 			Format: <blue0>,<blue1>,<blue2>,...,<blue15>
 			Change the default blue palette of the console.
 			This is a 16-member array composed of values
 			ranging from 0-255.
 
-	vt.default_grn=	[VT]
+	default_grn=	[VT]
 			Format: <green0>,<green1>,<green2>,...,<green15>
 			Change the default green palette of the console.
 			This is a 16-member array composed of values
 			ranging from 0-255.
 
-	vt.default_red=	[VT]
+	default_red=	[VT]
 			Format: <red0>,<red1>,<red2>,...,<red15>
 			Change the default red palette of the console.
 			This is a 16-member array composed of values
 			ranging from 0-255.
 
-	vt.default_utf8=
-			[VT]
+	default_utf8=   [VT]
 			Format=<0|1>
 			Set system-wide default UTF-8 mode for all tty's.
-			Default is 1, i.e. UTF-8 mode is enabled for all
-			newly opened terminals.
+			Default is 0 and by setting to 1, it enables UTF-8
+			mode for all newly opened or allocated terminals.
 
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
