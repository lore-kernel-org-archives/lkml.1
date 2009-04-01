Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbZDAOEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbZDAOEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbZDAOEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:04:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36476 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761777AbZDAOEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:04:05 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/24] 8250_pnp.c: add another Wacom tablet
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:04:36 +0100
Message-ID: <20090401140434.22882.15585.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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

