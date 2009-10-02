Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbZJBWpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbZJBWpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbZJBWpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:45:35 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56753 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbZJBWpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:45:34 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19p/NDVVpDN+1PEzGd9uwX3
Subject: [PATCH 7/8] omapfb: Blizzard: fix pointer to be const
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: Imre Deak <imre.deak@nokia.com>, Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Tommi Rantala <tt.rantala@gmail.com>, linux-omap@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 02 Oct 2009 15:45:37 -0700
Message-ID: <20091002224537.11962.13995.stgit@localhost>
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

Fixes a compiler warning:
warning: assignment discards qualifiers from pointer target type

Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: Imre Deak <imre.deak@nokia.com>
Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/video/omap/blizzard.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/omap/blizzard.c b/drivers/video/omap/blizzard.c
index d5e5955..ce28be6 100644
--- a/drivers/video/omap/blizzard.c
+++ b/drivers/video/omap/blizzard.c
@@ -191,7 +191,7 @@ struct blizzard_struct {
 
 	struct omapfb_device	*fbdev;
 	struct lcd_ctrl_extif	*extif;
-	struct lcd_ctrl		*int_ctrl;
+	const struct lcd_ctrl	*int_ctrl;
 
 	void			(*power_up)(struct device *dev);
 	void			(*power_down)(struct device *dev);

