Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166Ab0AGPx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0AGPx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116Ab0AGPxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:53:46 -0500
Received: from kroah.org ([198.145.64.141]:54044 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986Ab0AGPxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:53:46 -0500
Date: Thu, 7 Jan 2010 07:53:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.31.11
Message-ID: <20100107155311.GB15816@kroah.com>
References: <20100107155300.GA15816@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100107155300.GA15816@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index fe266ee..c66c167 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 31
-EXTRAVERSION = .10
+EXTRAVERSION = .11
 NAME = Man-Eating Seals of Antiquity
 
 # *DOCUMENTATION*
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0d99314..49b29ff 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2546,11 +2546,6 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 
 	/*
-	 * Disable powersaving as default.
-	 */
-	rt2x00dev->hw->wiphy->ps_default = false;
-
-	/*
 	 * Initialize all hw fields.
 	 */
 	rt2x00dev->hw->flags =
