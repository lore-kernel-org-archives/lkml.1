Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbZDFPmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbZDFPmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757150AbZDFPgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:36:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57005 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756989AbZDFPgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:36:44 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 26/27] rio: addition has higher precedence than ?:
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:35:34 +0100
Message-ID: <20090406163531.12934.26214.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/char/rio/rio_linux.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 2e8a6ee..ce81da5 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -333,7 +333,7 @@ void rio_copy_to_card(void *from, void __iomem *to, int len)
 
 int rio_minor(struct tty_struct *tty)
 {
-	return tty->index + (tty->driver == rio_driver) ? 0 : 256;
+	return tty->index + ((tty->driver == rio_driver) ? 0 : 256);
 }
 
 static int rio_set_real_termios(void *ptr)

