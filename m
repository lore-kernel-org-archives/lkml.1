Return-Path: <linux-kernel-owner+w=401wt.eu-S932844AbYFTUnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbYFTUnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762857AbYFTUYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:24:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58363 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762848AbYFTUYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:24:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 69/70] whiteheat: remove unused variable
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:07:22 +0100
Message-ID: <20080620200719.1479.89893.stgit@localhost.localdomain>
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

 drivers/usb/serial/whiteheat.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 0954191..afd1379 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -627,7 +627,6 @@ static int whiteheat_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
 	int		retval = 0;
-	struct ktermios	old_term;
 
 	dbg("%s - port %d", __func__, port->number);
 

