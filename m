Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935535Ab0CMAcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:32:25 -0500
Received: from kroah.org ([198.145.64.141]:46786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935388Ab0CMAbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:10 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:08 2010
Message-Id: <20100313002708.477320980@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roel Kluin <roel.kluin@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [037/145] sparc: leds_resource.end assigned to itself in clock_board_probe()
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Roel Kluin <roel.kluin@gmail.com>

[ Upstream commit 093171465235a8482fbf08a9a2e365247e1f7dd5 ]

It should be a 1 byte region.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/central.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/central.c
+++ b/arch/sparc/kernel/central.c
@@ -99,7 +99,7 @@ static int __devinit clock_board_probe(s
 
 	p->leds_resource.start = (unsigned long)
 		(p->clock_regs + CLOCK_CTRL);
-	p->leds_resource.end = p->leds_resource.end;
+	p->leds_resource.end = p->leds_resource.start;
 	p->leds_resource.name = "leds";
 
 	p->leds_pdev.name = "sunfire-clockboard-leds";
@@ -194,7 +194,7 @@ static int __devinit fhc_probe(struct of
 	if (!p->central) {
 		p->leds_resource.start = (unsigned long)
 			(p->pregs + FHC_PREGS_CTRL);
-		p->leds_resource.end = p->leds_resource.end;
+		p->leds_resource.end = p->leds_resource.start;
 		p->leds_resource.name = "leds";
 
 		p->leds_pdev.name = "sunfire-fhc-leds";


