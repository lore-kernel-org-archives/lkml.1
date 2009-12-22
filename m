Return-Path: <linux-kernel-owner+w=401wt.eu-S1751741AbZLVIlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbZLVIlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 03:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZLVIlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 03:41:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:37794 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750896AbZLVIln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:41:43 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+eygQvqMKegruXG9BEpeX+lxmJZuqNo1wpbgHp5D
	3Tzh2ucnqDTvgo
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] isdn/mISDN: add __init/__exit macros to drivers/isdn/mISDN/dsp_core.c
Date: Tue, 22 Dec 2009 09:41:42 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: kernel-janitors@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>,
       Karsten Keil <isdn@linux-pingi.de>,
       Andreas Eversberg <andreas@eversberg.eu>,
       "David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <200912220941.42370.PeterHuewe@gmx.de>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

Trivial patch which adds the __init/__exit macros to the module_init/
module_exit functions of

drivers/isdn/mISDN/dsp_core.c

Please have a look at the small patch and either pull it through
your tree, or please ack' it so Jiri can pull it through the trivial
tree.

Patch against linux-next-tree, 22. Dez 08:38:18 CET 2009
but also present in linus tree.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/isdn/mISDN/dsp_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 43ff4d3..6eac588 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -1114,7 +1114,7 @@ static struct Bprotocol DSP = {
 	.create = dspcreate
 };
 
-static int dsp_init(void)
+static int __init dsp_init(void)
 {
 	int err;
 	int tics;
@@ -1212,7 +1212,7 @@ static int dsp_init(void)
 }
 
 
-static void dsp_cleanup(void)
+static void __exit dsp_cleanup(void)
 {
 	mISDN_unregister_Bprotocol(&DSP);
 
-- 
1.6.4.4

