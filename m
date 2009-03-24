Return-Path: <linux-kernel-owner+w=401wt.eu-S1760774AbZCXOLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774AbZCXOLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbZCXOEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:04:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48979 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757817AbZCXOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:04:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 20/30] rio: addition has higher precedence than ?:
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:05:11 +0000
Message-ID: <20090324140509.12735.24947.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
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

