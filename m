Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbZBLKgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbZBLKgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbZBLKgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:36:32 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:3192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbZBLKgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dFQUcuub+LvB1CwaJlqayGYF1asySj3oKvRpVWcghBrYFBa7FIGTnGIgaKEIvEWjT3
         8HDHBaSUPOc606IW7xqIXgj3WhtfhES143G2ct+izOkm6X2jl6TdSIkLzo+jGnQLXZey
         YPvvfJJWragwMiEB8CWkoCUnq1zqi/f9zJPo4=
Date: Thu, 12 Feb 2009 13:42:41 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, wim@iguana.be
Subject: next-20090212: drivers/watchdog/ks8695_wdt.c:68: error:
	'CLOCK_TICK_RATE' undeclared (first use in this function)
Message-ID: <20090212104241.GA7978@x200.localdomain>
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On arm-acs5k_tiny:

drivers/watchdog/ks8695_wdt.c:68: error: 'CLOCK_TICK_RATE' undeclared (first use in this function)

--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -21,6 +21,7 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <mach/timex.h>
 #include <mach/regs-timer.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
