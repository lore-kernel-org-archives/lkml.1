Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZCXOC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZCXOC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757232AbZCXOBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:01:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48924 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757298AbZCXOBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:01:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 02/30] 8250_pnp.c: add another Wacom tablet
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:02:03 +0000
Message-ID: <20090324140157.12735.34565.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
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

