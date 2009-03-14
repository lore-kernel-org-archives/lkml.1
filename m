Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbZCNB2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbZCNB2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZCNBUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:13 -0400
Received: from kroah.org ([198.145.64.141]:34951 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753087AbZCNBUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:05 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:34 2009
Message-Id: <20090314011034.790870402@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:00 -0700
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
Subject: [patch 023/114] WATCHDOG: ks8695_wdt.c: CLOCK_TICK_RATE undeclared
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=watchdog-ks8695_wdt.c-clock_tick_rate-undeclared.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

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


