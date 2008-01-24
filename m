Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYAXPSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYAXPSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYAXPSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:18:23 -0500
Received: from mail0.scram.de ([78.47.204.202]:58512 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYAXPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:18:22 -0500
X-Spam-Score: -4.247
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4798AC2B.2040505@scram.de>
Date: Thu, 24 Jan 2008 16:18:03 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv3 3/7] [POWERPC] Remove unneeded and misspelled prototype
 m8xx_calibrate_decr
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m8xx_calibrate_decr seems to be a misspelled prototype for
mpc8xx_calibrate_decr. As it's not needed anyways, just remove it.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
 arch/powerpc/platforms/8xx/m8xx_setup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index 1337457..85abd61 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -31,7 +31,6 @@
 struct mpc8xx_pcmcia_ops m8xx_pcmcia_ops;
 #endif
 
-void m8xx_calibrate_decr(void);
 extern int cpm_pic_init(void);
 extern int cpm_get_irq(void);
 
-- 
1.5.3.8


