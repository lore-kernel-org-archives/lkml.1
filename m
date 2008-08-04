Return-Path: <linux-kernel-owner+w=401wt.eu-S1763344AbYHDUVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763344AbYHDUVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763260AbYHDUVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:21:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:48382 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763252AbYHDUVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:21:16 -0400
Date: Mon, 4 Aug 2008 13:14:52 -0700
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
       alan@lxorguk.ukuu.org.uk,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Paul Mackerras <paulus@samba.org>, Jeff Mahoney <jeffm@suse.com>
Subject: [patch 05/33] POWERPC: PS3: Add time include to lpm
Message-ID: <20080804201452.GF1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-ps3-add-time-include-to-lpm.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit 483d8876f75aa5707a646442377051f1b90db206 upstream

Add an include <asm/time.h> statement for get_tb().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ps3/ps3-lpm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ps3/ps3-lpm.c
+++ b/drivers/ps3/ps3-lpm.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
+#include <asm/time.h>
 #include <asm/ps3.h>
 #include <asm/lv1call.h>
 #include <asm/cell-pmu.h>

-- 
