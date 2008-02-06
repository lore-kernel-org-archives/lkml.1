Return-Path: <linux-kernel-owner+w=401wt.eu-S1764895AbYBGACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764895AbYBGACy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764346AbYBFXzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:55:01 -0500
Received: from ns2.suse.de ([195.135.220.15]:60103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762230AbYBFXy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:59 -0500
Date: Wed, 6 Feb 2008 15:51:51 -0800
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
Subject: [patch 18/73] NET: kaweth was forgotten in msec switchover of
	usb_start_wait_urb
Message-ID: <20080206235151.GS13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-kaweth-was-forgotten-in-msec-switchover-of-usb_start_wait_urb.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
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
