Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZJBWqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZJBWqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756385AbZJBWqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:46:51 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52159 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944AbZJBWqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:46:50 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX197Q4fVgH7vNXw6XkqqTMWR
Subject: [PATCH 8/8] omapfb: Blizzard: constify register address tables
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Imre Deak <imre.deak@nokia.com>, Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Tommi Rantala <tt.rantala@gmail.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 02 Oct 2009 15:46:53 -0700
Message-ID: <20091002224653.11962.4623.stgit@localhost>
In-Reply-To: <20091002223510.11962.21751.stgit@localhost>
References: <20091002223510.11962.21751.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tommi Rantala <tt.rantala@gmail.com>

Constify register address tables

Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Imre Deak <imre.deak@nokia.com>
Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/video/omap/blizzard.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/omap/blizzard.c b/drivers/video/omap/blizzard.c
index ce28be6..70dadf9 100644
--- a/drivers/video/omap/blizzard.c
+++ b/drivers/video/omap/blizzard.c
@@ -93,7 +93,7 @@ struct blizzard_reg_list {
 };
 
 /* These need to be saved / restored separately from the rest. */
-static struct blizzard_reg_list blizzard_pll_regs[] = {
+static const struct blizzard_reg_list blizzard_pll_regs[] = {
 	{
 		.start	= 0x04,		/* Don't save PLL ctrl (0x0C) */
 		.end	= 0x0a,
@@ -104,7 +104,7 @@ static struct blizzard_reg_list blizzard_pll_regs[] = {
 	},
 };
 
-static struct blizzard_reg_list blizzard_gen_regs[] = {
+static const struct blizzard_reg_list blizzard_gen_regs[] = {
 	{
 		.start	= 0x18,		/* SDRAM control */
 		.end	= 0x20,
@@ -1372,7 +1372,7 @@ static void blizzard_get_caps(int plane, struct omapfb_caps *caps)
 			   (1 << OMAPFB_COLOR_YUV420);
 }
 
-static void _save_regs(struct blizzard_reg_list *list, int cnt)
+static void _save_regs(const struct blizzard_reg_list *list, int cnt)
 {
 	int i;
 
@@ -1383,7 +1383,7 @@ static void _save_regs(struct blizzard_reg_list *list, int cnt)
 	}
 }
 
-static void _restore_regs(struct blizzard_reg_list *list, int cnt)
+static void _restore_regs(const struct blizzard_reg_list *list, int cnt)
 {
 	int i;
 

