Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYAWQAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYAWQAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYAWQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:00:43 -0500
Received: from mail0.scram.de ([78.47.204.202]:41028 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbYAWQAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:00:42 -0500
X-Spam-Score: -4.198
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <47976499.9050505@scram.de>
Date: Wed, 23 Jan 2008 17:00:25 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
CC: Kumar Gala <galak@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: [PATCHv2 4/8] [POWERPC] Remove declaration of m8xx_pic_init.
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m8xx_pic_init is declared in ppc8xx_pic.h but defined nowhere in the ppc
tree. Remove it.

Signed-off-by: Jochen Friedrich <jochen@scram.de>
---
  arch/ppc/syslib/ppc8xx_pic.h |    1 -
  1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/ppc/syslib/ppc8xx_pic.h b/arch/ppc/syslib/ppc8xx_pic.h
index d7d9f65..53bcd97 100644
--- a/arch/ppc/syslib/ppc8xx_pic.h
+++ b/arch/ppc/syslib/ppc8xx_pic.h
@@ -6,7 +6,6 @@

  extern struct hw_interrupt_type ppc8xx_pic;

-void m8xx_pic_init(void);
  void m8xx_do_IRQ(struct pt_regs *regs,
                   int            cpu);
  int m8xx_get_irq(struct pt_regs *regs);
-- 
1.5.3.8


