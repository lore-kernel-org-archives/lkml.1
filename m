Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbXFLXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbXFLXDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbXFLXDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:03:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33075 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753373AbXFLXDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:03:03 -0400
Date: Wed, 13 Jun 2007 01:03:15 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [-mm patch] make drivers/acpi/osl.c:osi_linux static
Message-ID: <20070612230315.GA3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 10:03:13PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm1:
> 
>  git-acpi.patch
>...
>  git trees
>...


This patch makes the needlessly global osi_linux static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/drivers/acpi/osl.c.old	2007-06-12 23:55:27.000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/acpi/osl.c	2007-06-12 23:55:37.000000000 +0200
@@ -78,9 +78,9 @@
 static char osi_additional_string[OSI_STRING_LENGTH_MAX];
 
 #ifdef	OSI_LINUX_ENABLED
-int osi_linux = 1;	/* enable _OSI(Linux) by default */
+static int osi_linux = 1;	/* enable _OSI(Linux) by default */
 #else
-int osi_linux;		/* disable _OSI(Linux) by default */
+static int osi_linux;		/* disable _OSI(Linux) by default */
 #endif
 
 

