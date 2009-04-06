Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZDFPci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZDFPci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbZDFPc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:32:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46780 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753649AbZDFPcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:32:25 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/27] 8250_pnp.c: add another Wacom tablet
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:31:54 +0100
Message-ID: <20090406163150.12934.23200.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Danny Kukawka <dkukawka@suse.de>

Add another serial Wacom tablet with pnp_id: WACF009.

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
Signed-off-by: Alan Cox <alan@etchedpixels.co.uk>
--
 8250_pnp.c |    1 +
 1 file changed, 1 insertion(+)
---

 drivers/serial/8250_pnp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


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

