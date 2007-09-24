Return-Path: <linux-kernel-owner+w=401wt.eu-S1763341AbXIXQmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763341AbXIXQmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760700AbXIXQ2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:33 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58109 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760563AbXIXQ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:31 -0400
Date: Mon, 24 Sep 2007 09:22:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [44/50] Fix tc_ematch kbuild
Message-ID: <20070924162234.GS13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-tc_ematch-kbuild.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Stephen Hemminger <shemminger@linux-foundation.org>

commit 09d74cdd88a59a18f2ad7cfa0b6045ed1817b632 in mainline.

Subject: [44/50] [PATCH] [KBUILD]: Sanitize tc_ematch headers.

The headers in tc_ematch are used by iproute2, so these headers should
be processed.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -7,6 +7,7 @@ header-y += raid/
 header-y += spi/
 header-y += sunrpc/
 header-y += tc_act/
+header-y += tc_ematch/
 header-y += netfilter/
 header-y += netfilter_arp/
 header-y += netfilter_bridge/

-- 
