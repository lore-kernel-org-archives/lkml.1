Return-Path: <linux-kernel-owner+w=401wt.eu-S964827AbXBFQIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827AbXBFQIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964972AbXBFQIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:08:42 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:59552 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827AbXBFQIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:08:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=XrlFywfURhWihX5ZNHJFN/6X9ldxgaP30wIU12b06JNeUaWnjq9aMCWIpmiOf7yruAsROaaARfPc7YnpxY6xZBx0c3lheAU+Kw5GIeb9BR9Sj73wEUDXBVgdbkwDCOYLeKLnU6NnrHNDggnfczoHBC/MiMOyHM5wG8MSHpC7JaQ=
Date: Tue, 6 Feb 2007 18:08:28 +0200
To: davej@codemonkey.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] intel-agp: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160828.GM8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index ab0a9c0..7233310 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/agp_backend.h>
 #include "agp.h"
@@ -803,7 +804,7 @@ static int intel_i915_remove_entries(struct agp_memory *mem,off_t pg_start,
  */
 static int intel_i9xx_fetch_size(void)
 {
-	int num_sizes = sizeof(intel_i830_sizes) / sizeof(*intel_i830_sizes);
+	int num_sizes = ARRAY_SIZE(intel_i830_sizes);
 	int aper_size; /* size in megabytes */
 	int i;
 


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
