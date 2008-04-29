Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYD2Rb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYD2Rb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbYD2RV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:57 -0400
Received: from ns1.suse.de ([195.135.220.2]:52522 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759337AbYD2RVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:55 -0400
Date: Tue, 29 Apr 2008 10:19:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Brownell <dbrownell@users.sourceforge.net>,
       Adrian Bunk <bunk@kernel.org>, Alessandro Zummo <a.zummo@towertech.it>
Subject: [29/37] rtc-pcf8583 build fix
Message-ID: <20080429171906.GD14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtc-pcf8583-build-fix.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Brownell <dbrownell@users.sourceforge.net>

commit 77459b059b02c16b2c8cbc39b524941a576ad36e upstream


Fix bogus #include in rtc-pcf8583, so it compiles on platforms that
don't support PC clone RTCs.  (Original issue noted by Adrian Bunk.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Adrian Bunk <bunk@kernel.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-pcf8583.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -15,7 +15,7 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/mc146818rtc.h>
+#include <linux/rtc.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/bcd.h>

-- 
