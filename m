Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbXHSWlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbXHSWlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXHSWlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:41:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1573 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXHSWlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:41:12 -0400
Subject: Re: [PATCH 4/5] Documentation/firmware/... convert #include
	"linux/..." to #include <linux/...>
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Markus Rechberger <markus.rechberger@amd.com>
In-Reply-To: <20070819154146.337bf347.randy.dunlap@oracle.com>
References: <1187561972.4200.143.camel@localhost>
	 <20070819153422.1e0b54af.randy.dunlap@oracle.com>
	 <1187562717.4200.154.camel@localhost>
	 <20070819154146.337bf347.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Sun, 19 Aug 2007 15:41:07 -0700
Message-Id: <1187563268.4200.162.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-19 at 15:41 -0700, Randy Dunlap wrote:
> It's not only included in that directory.
> I find it included in 88 source files throughout the kernel tree.

I see, sorry.  I didn't read the file.
I thought it was a sample driver with a binary blob.

cheers,  Joe

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/Documentation/firmware_class/firmware_sample_driver.c b/Documentation/firmware_class/firmware_sample_driver.c
index 6865cbe..754ded2 100644
--- a/Documentation/firmware_class/firmware_sample_driver.c
+++ b/Documentation/firmware_class/firmware_sample_driver.c
@@ -13,7 +13,7 @@
 #include <linux/device.h>
 #include <linux/string.h>
 
-#include "linux/firmware.h"
+#include <linux/firmware.h>
 
 static struct device ghost_device = {
 	.bus_id    = "ghost0",



