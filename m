Return-Path: <linux-kernel-owner+w=401wt.eu-S932578AbXG2PI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578AbXG2PI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764743AbXG2O7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:24 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47850 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764556AbXG2O7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:22 -0400
Date: Sun, 29 Jul 2007 16:58:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [-mm patch] USB: make dev_attr_authorized_default static
Message-ID: <20070729145858.GC16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
>...
>  USB tree updates
>...

dev_attr_authorized_default can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/usb/core/hcd.c.old	2007-07-26 21:50:30.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/usb/core/hcd.c	2007-07-26 21:50:45.000000000 +0200
@@ -717,9 +717,9 @@
 	return result;
 }
 
-DEVICE_ATTR(authorized_default, 0644,
-	    usb_host_authorized_default_show,
-	    usb_host_authorized_default_store);
+static DEVICE_ATTR(authorized_default, 0644,
+		   usb_host_authorized_default_show,
+		   usb_host_authorized_default_store);
 
 
 /* Group all the USB bus attributes */

