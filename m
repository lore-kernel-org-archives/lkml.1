Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbZFOOeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbZFOOeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 10:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760547AbZFOOdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 10:33:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57568 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759964AbZFOOdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 10:33:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] ldisc: debug aids
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Date: Mon, 15 Jun 2009 16:32:20 +0100
Message-ID: <20090615153217.4036.96373.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090615153015.4036.76588.stgit@t61.ukuu.org.uk>
References: <20090615153015.4036.76588.stgit@t61.ukuu.org.uk>
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
 

