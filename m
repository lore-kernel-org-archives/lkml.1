Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYAWQAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYAWQAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYAWQAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:00:22 -0500
Received: from mail0.scram.de ([78.47.204.202]:49731 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbYAWQAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:00:20 -0500
X-Spam-Score: -4.197
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47976477.1020901@scram.de>
Date: Wed, 23 Jan 2008 16:59:51 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv2 3/8] [POWERPC] Remove unneeded and misspelled prototype
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


