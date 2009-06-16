Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbZFPPCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbZFPPCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759144AbZFPPCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:02:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44034 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759196AbZFPPCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:02:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/9] ldisc: debug aids
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Jun 2009 17:00:53 +0100
Message-ID: <20090616160045.10041.94585.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
References: <20090616155552.10041.63479.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>


---

 drivers/char/tty_ldisc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 874c248..a19e935 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -207,6 +207,7 @@ static void tty_ldisc_put(struct tty_ldisc *ld)
 	ldo->refcount--;
 	module_put(ldo->owner);
 	spin_unlock_irqrestore(&tty_ldisc_lock, flags);
+	WARN_ON(ld->refcount);
 	kfree(ld);
 }
 

