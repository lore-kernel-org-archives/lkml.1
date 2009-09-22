Return-Path: <linux-kernel-owner+w=401wt.eu-S1751463AbZIVSlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbZIVSlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZIVSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:41:54 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:41365 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbZIVSlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=U0lkw3knNIVhuZ2rzNIs5aYpY3PpjcWD8yXA7mwhDkdB0UbmYYDiVRzPvhxc/95+2I
         zinSwXAAxpOBGCCM2pIPZplFLxS/Syyw7h1bFkT7Wxk6R1qgdeEKWX/bVFb/ZRTRe/pc
         CV0BnA0jmHt+qFnwf8NU1A4s5lMSByQIe6PXA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Tue, 22 Sep 2009 20:43:39 +0200
Message-Id: <20090922184339.7695.75319.sendpatchset@localhost.localdomain>
In-Reply-To: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
References: <20090922184321.7695.11150.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/8] Staging: rt3090: disable HAS_ANTENNA_DIVERSITY_SUPPORT option
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt3090: disable HAS_ANTENNA_DIVERSITY_SUPPORT option

This makes rt3090 match other Ralink drivers and V2.2.0.0 vendor version.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt3090/config.mk |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/staging/rt3090/config.mk
===================================================================
--- a/drivers/staging/rt3090/config.mk
+++ b/drivers/staging/rt3090/config.mk
@@ -84,7 +84,7 @@ HAS_AUTO_CH_SELECT_ENHANCE=n
 HAS_BG_FT_SUPPORT=n
 
 #Support Antenna Diversity
-HAS_ANTENNA_DIVERSITY_SUPPORT=y
+HAS_ANTENNA_DIVERSITY_SUPPORT=n
 #################################################
 
 WFLAGS := -DAGGREGATION_SUPPORT -DPIGGYBACK_SUPPORT -DWMM_SUPPORT  -DLINUX -Wall -Wstrict-prototypes -Wno-trigraphs -Wpointer-sign
