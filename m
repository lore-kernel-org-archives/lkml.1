Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZCKQn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZCKQn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZCKQnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:43:19 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:39562 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbZCKQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:43:18 -0400
Date: Wed, 11 Mar 2009 17:43:11 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Jean Delvare <khali@linux-fr.org>,
       linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Added driver for ISL29003 ambient light sensor
Message-ID: <20090311164311.GC29871@buzzloop.caiaq.de>
References: <20090307120631.GA25276@buzzloop.caiaq.de> <20090307130818.367bcaad@hyperion.delvare> <20090309210901.GC31367@buzzloop.caiaq.de> <49B666F9.50209@cam.ac.uk> <20090310151542.GE9564@buzzloop.caiaq.de> <49B6A843.3090902@cam.ac.uk> <20090311003155.GB21160@buzzloop.caiaq.de> <20090310212826.7d8b3d4e.akpm@linux-foundation.org> <20090311083252.GB25824@buzzloop.caiaq.de> <20090311093234.7e8e5416.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311093234.7e8e5416.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 09:32:34AM -0700, Andrew Morton wrote:
> > Jonathan replied to the posting on linux-i2c and linux-kernel wasn't in
> > the loop, sorry. Find his posting here:
> > 
> > 	http://marc.info/?l=linux-i2c&m=123669064909549&w=2
> 
> OK.  Please always use reply-to-all, guys.

The thread moved from linux-i2c to linux-kernel, hence the trouble.

> > You're right, it should depend on that. You want me so send a patch on
> > top of the other or one that replaces it?
> 
> Either way is OK by me at this time.

Ok, I chose the shorter variant :) See the patch below.

Thanks,
Daniel


>From 9143c849682280ca3b0544e580bc90241c385927 Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Wed, 11 Mar 2009 17:39:13 +0100
Subject: [PATCH] make isl29003 depend on sysfs


Signed-off-by: Daniel Mack <daniel@caiaq.de>
---
 drivers/misc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index b883b19..16e1815 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -225,7 +225,7 @@ config DELL_LAPTOP
 
 config ISL29003
 	tristate "Intersil ISL29003 ambient light sensor"
-	depends on I2C
+	depends on I2C && SYSFS
 	help
 	  If you say yes here you get support for the Intersil ISL29003
 	  ambient light sensor.
-- 
1.6.2

