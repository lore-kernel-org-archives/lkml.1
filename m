Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYK0P6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYK0P6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYK0P6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:58:44 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:51678 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYK0P6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:58:43 -0500
From: Yuri Tikhonov <yur@emcraft.com>
To: Paul Mackerras <paulus@samba.org>
Subject: [PATCH] xsysace: add compatible string
Date: Thu, 27 Nov 2008 18:49:58 +0300
User-Agent: KMail/1.9.4
Cc: linux-kernel@vger.kernel.org, Wolfgang Denk <wd@denx.de>,
       Detlev Zundel <dzu@denx.de>, Ilya Yanok <yanok@emcraft.com>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811271849.58535.yur@emcraft.com>
X-Spam-Score: -3.8 (---)
X-Spam-Report: Spam detection software, running on the system "pacific.emcraft.com", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Add one more compatible string to the table for of_platform
	binding, so that the platforms, which have the SysACE chip on board (e.g.
	Katmai), could describe it in their device trees correctly. Signed-off-by:
	Yuri Tikhonov <yur@emcraft.com> --- drivers/block/xsysace.c | 1 + 1 files
	changed, 1 insertions(+), 0 deletions(-) [...] 
	Content analysis details:   (-3.8 points, 2.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.6 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add one more compatible string to the table for
of_platform binding, so that the platforms, which
have the SysACE chip on board (e.g. Katmai), could
describe it in their device trees correctly.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
---
 drivers/block/xsysace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 29e1dfa..381d686 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1206,6 +1206,7 @@ static struct of_device_id ace_of_match[] __devinitdata = {
 	{ .compatible = "xlnx,opb-sysace-1.00.b", },
 	{ .compatible = "xlnx,opb-sysace-1.00.c", },
 	{ .compatible = "xlnx,xps-sysace-1.00.a", },
+	{ .compatible = "xlnx,sysace", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ace_of_match);
-- 
1.5.6.1
