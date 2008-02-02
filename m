Return-Path: <linux-kernel-owner+w=401wt.eu-S1763608AbYBBAZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763608AbYBBAZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762930AbYBBAYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:24:13 -0500
Received: from ns1.suse.de ([195.135.220.2]:54526 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762922AbYBBAYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:24:11 -0500
Date: Fri, 1 Feb 2008 16:20:06 -0800
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
       Russ Dill <Russ.Dill@asu.edu>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 05/27] NET: kaweth was forgotten in msec switchover of
	usb_start_wait_urb
Message-ID: <20080202002006.GF8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-kaweth-was-forgotten-in-msec-switchover-of-usb_start_wait_urb.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Russ Dill <Russ.Dill@asu.edu>

[NET]: kaweth was forgotten in msec switchover of usb_start_wait_urb

[ Upstream commit: 2b2b2e35b71e5be8bc06cc0ff38df15dfedda19b ]

Back in 2.6.12-pre, usb_start_wait_urb was switched over to take
milliseconds instead of jiffies. kaweth.c was never updated to match.

Signed-off-by: Russ Dill <Russ.Dill@asu.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/kaweth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -70,7 +70,7 @@
 #define KAWETH_TX_TIMEOUT		(5 * HZ)
 #define KAWETH_SCRATCH_SIZE		32
 #define KAWETH_FIRMWARE_BUF_SIZE	4096
-#define KAWETH_CONTROL_TIMEOUT		(30 * HZ)
+#define KAWETH_CONTROL_TIMEOUT		(30000)
 
 #define KAWETH_STATUS_BROKEN		0x0000001
 #define KAWETH_STATUS_CLOSING		0x0000002

-- 
