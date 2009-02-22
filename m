Return-Path: <linux-kernel-owner+w=401wt.eu-S1753043AbZBVTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbZBVTQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZBVTQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:16:11 -0500
Received: from mx1.suse.de ([195.135.220.2]:34986 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbZBVTQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:16:10 -0500
From: Danny Kukawka <dkukawka@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 8250_pnp.c: add another serial Wacom tablet
Date: Sun, 22 Feb 2009 20:16:06 +0100
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902222016.06946.dkukawka@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <dkukawka@suse.de>
Subject: 8250_pnp.c: add another Wacom tablet

Add another serial Wacom tablet with pnp_id: WACF009.

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
--
 8250_pnp.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index bbcfc26..6db9f13 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -333,6 +333,7 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	{       "WACF006",              0       },
 	{       "WACF007",              0       },
 	{       "WACF008",              0       },
+	{       "WACF009",              0       },
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */

-- 
Danny Kukawka
dkukawka@suse.de
R&D Team Mobile Devices
SUSE LINUX a Novell Business
Maxfeldstr. 5, D-90409 Nuernberg, Germany
SUSE LINUX Products GmbH, Nuernberg; GF: Markus Rex, HRB 16746 (AG Nuernberg)
