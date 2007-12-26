Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXLZIcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXLZIcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 03:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXLZIcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 03:32:06 -0500
Received: from smtp5-g19.free.fr ([212.27.42.35]:39869 "EHLO smtp5-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbXLZIcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 03:32:05 -0500
Date: Wed, 26 Dec 2007 09:32:00 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, torvalds@osdl.org
Subject: Re: [PATCH][DOC] Console is utf-8 by default
Message-ID: <20071226083200.GA4156@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, torvalds@osdl.org
References: <20071225231144.GA4061@implementation> <47719611.6030502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47719611.6030502@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin, le Tue 25 Dec 2007 15:45:21 -0800, a écrit :
> Samuel Thibault wrote:
> >The console is now by default in UTF-8 mode, so let's document this.
> >BTW, document the needed "vt." prefix.
> >
> >-	vt.default_blu=	[VT]
> >+	default_blu=	[VT]
> 
> Reverse patch?

Erf, yes, it looks like I modified the .orig file.... Here it is again,
in the proper way.


The console is now by default in UTF-8 mode, so let's document this.
BTW, document the needed "vt." prefix.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

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
