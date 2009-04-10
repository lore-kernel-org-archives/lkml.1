Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbZDJPvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbZDJPvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 11:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZDJPu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 11:50:56 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:47095 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbZDJPuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 11:50:55 -0400
X-IronPort-AV: E=Sophos;i="4.40,168,1238990400"; 
   d="scan'208";a="86108690"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH 01/01] - Add IRQF_SAMPLE_RANDOM to the feature-removal-schedule.txt (deprecated) list
Date: Fri, 10 Apr 2009 11:53:09 -0400
User-Agent: KMail/1.9.5
CC: "Theodore Tso" <tytso@mit.edu>, "Matt Mackall" <mpm@selenic.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, mtk.manpages@gmail.com,
       "Randy Dunlap" <randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200904101153.09416.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 10 Apr 2009 15:50:49.0578 (UTC) FILETIME=[1EBF44A0:01C9B9F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds IRQF_SAMPLE_RANDOM to the feature-removal (deprecated) list since 
most of the IRQF_SAMPLE_RANDOM users are technically bogus as entropy sources 
in the kernel's current entropy model.

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

---

This was discussed on the lkml the past few days, which started here:
http://lkml.org/lkml/2009/4/6/283

 Documentation/feature-removal-schedule.txt2 |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- Documentation/feature-removal-schedule.txt	
+++ Documentation/feature-removal-schedule.txt
@@ -6,6 +6,20 @@
 
 ---------------------------
 
+What:	IRQF_SAMPLE_RANDOM
+Check:	IRQF_SAMPLE_RANDOM
+When:	July 2009
+
+Why:	Many of IRQF_SAMPLE_RANDOM users are technically bogus as entropy
+	sources in the kernel's current entropy model. To resolve this, every
+	input point to the kernel's entropy pool needs to better document the
+	type of entropy source it actually is. This will be replaced with
+	additional add_*_randomness functions in drivers/char/random.c
+
+Who:	Robin Getz <rgetz@blackfin.uclinux.org> & Matt Mackall <mpm@selenic.com>
+
+---------------------------
+
 What:	The ieee80211_regdom module parameter
 When:	March 2010 / desktop catchup
 

---
