Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZKPPbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZKPPbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:31:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZKPPbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:31:09 -0500
Received: from mail.atmel.fr ([81.80.104.162]:57448 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752632AbZKPPbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:31:08 -0500
Message-ID: <4B01702B.4080107@atmel.com>
Date: Mon, 16 Nov 2009 16:30:51 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
CC: Andrew Victor <linux@maxim.org.za>,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: [GIT PULL] AT91 Kconfig rework
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

This is AT91 Kconfig rework for next merge window. After 
discussing it on the mailing-list and Ack by Andrew Victor, I 
send you this patchset. You can pull it from:

  git://github.com/at91linux/linux-2.6-at91.git for-rmk

And you will receive:

Jean-Christophe PLAGNIOL-VILLARD (2):
      at91: remove not needed depends on
      at91: Kconfig simplification

Nicolas Ferre (2):
      at91: at91sam9g20ek modify dual slot evaluation kit
      atmel_lcdfb Kconfig: remove long dependency line

 arch/arm/mach-at91/Kconfig                     |  107 ++++++++++++++----------
 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c |   23 ++++--
 arch/avr32/Kconfig                             |    1 +
 drivers/video/Kconfig                          |    5 +-
 4 files changed, 83 insertions(+), 53 deletions(-)

The patch
"at91: at91sam9g20ek modify dual slot evaluation kit"
is also already sent directly to Linus for .32-final (not 
sure it can reach). Anyway, I guess that git can handle 
that...

Thanks. Best regards,
-- 
Nicolas Ferre


