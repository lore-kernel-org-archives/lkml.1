Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZCNA1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZCNA1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZCNASv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:51 -0400
Received: from kroah.org ([198.145.64.141]:46843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752844AbZCNASo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:44 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:42 2009
Message-Id: <20090314000742.507112552@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexey Dobriyan <adobriyan@gmail.com>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: [patch 24/96] WATCHDOG: ks8695_wdt.c: CLOCK_TICK_RATE undeclared
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=watchdog-ks8695_wdt.c-clock_tick_rate-undeclared.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit b02c387892fc6b3cc59c78ab2f79413d55f50190 upstream.

On arm-acs5k_tiny:

drivers/watchdog/ks8695_wdt.c:68: error: 'CLOCK_TICK_RATE' undeclared
	(first use in this function)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/ks8695_wdt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -21,6 +21,7 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <mach/timex.h>
 #include <mach/regs-timer.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */


