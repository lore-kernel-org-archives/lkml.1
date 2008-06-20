Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbYFTUke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbYFTUke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762594AbYFTUXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:23:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58347 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762588AbYFTUXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:23:44 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 61/70] tty-usb-spcp8x5: Minor coding style
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:06:20 +0100
Message-ID: <20080620200618.1479.35383.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>



Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/spcp8x5.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 58495f5..283cf6b 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -208,7 +208,7 @@ static inline unsigned int ringbuf_avail_data(struct ringbuf *pb)
 {
 	if (pb == NULL)
 		return 0;
-	return ((pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size);
+	return (pb->buf_size + pb->buf_put - pb->buf_get) % pb->buf_size;
 }
 
 /* get the number of space in the pipo */
@@ -216,7 +216,7 @@ static inline unsigned int ringbuf_avail_space(struct ringbuf *pb)
 {
 	if (pb == NULL)
 		return 0;
-	return ((pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size);
+	return (pb->buf_size + pb->buf_get - pb->buf_put - 1) % pb->buf_size;
 }
 
 /* put count data into pipo */

