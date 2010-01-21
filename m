Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470Ab0AUEY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0AUEY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288Ab0AUEYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:24:41 -0500
Received: from kroah.org ([198.145.64.141]:60205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab0AUEXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:36 2010
Message-Id: <20100121041836.148602112@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ping Cheng <pingc@wacom.com>, Dmitry Torokhov <dtor@mail.ru>
Subject: [28/30] serial/8250_pnp: add a new Fujitsu Wacom Tablet PC device
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ping <pinglinux@gmail.com>

commit 3018aa4b1a46946dfd0ee73a533038f24e390539 upstream.

This is a new two finger touch Fujitsu Wacom Tablet PC.

Signed-off-by: Ping Cheng <pingc@wacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pnp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -354,6 +354,8 @@ static const struct pnp_device_id pnp_de
 	{	"FUJ02E5",		0	},
 	/* Fujitsu P-series tablet PC device */
 	{	"FUJ02E6",		0	},
+	/* Fujitsu Wacom 2FGT Tablet PC device */
+	{	"FUJ02E7",		0	},
 	/*
 	 * LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in
 	 * disguise)


