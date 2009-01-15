Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZAONbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZAONbB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764733AbZAONah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:30:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60781 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764720AbZAONag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:30:36 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/8] serial: Add SupraExpress 336i PnP Voice Modem
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:30:45 +0000
Message-ID: <20090115133040.21366.58495.stgit@localhost.localdomain>
In-Reply-To: <20090115132718.21366.56187.stgit@localhost.localdomain>
References: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Gagnon <daniel.gagnon@yahoo.com>

Add SupraExpress 336i PnP Voice Modem

Tested and working with the following device: (output from lspnp -v)
01:01.00 SUP1381 (unknown)
    state = active
	io 0x2f8-0x2ff
	irq 3

Signed-off-by: Daniel Gagnon <daniel.gagnon@yahoo.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/8250_pnp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index fde7f9c..bbcfc26 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -270,6 +270,8 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{       "RSS0250",              0       },
 	/* SupraExpress 28.8 Data/Fax PnP modem */
 	{	"SUP1310",		0	},
+	/* SupraExpress 336i PnP Voice Modem */
+	{	"SUP1381",		0	},
 	/* SupraExpress 33.6 Data/Fax PnP modem */
 	{	"SUP1421",		0	},
 	/* SupraExpress 33.6 Data/Fax PnP modem */

