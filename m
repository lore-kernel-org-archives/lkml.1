Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbZKPPNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbZKPPNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZKPPNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:13:07 -0500
Received: from mail.atmel.fr ([81.80.104.162]:54584 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752714AbZKPPNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:13:06 -0500
Message-ID: <4B016B8D.40701@atmel.com>
Date: Mon, 16 Nov 2009 16:11:09 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
CC: Andrew Victor <linux@maxim.org.za>
Subject: [GIT PULL] AT91 board fix for 2.6.32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

If it can reach mainline before .32-final, maybe you 
can pull:

  git://github.com/at91linux/linux-2.6-at91.git for-linus

and receive the following change:

Nicolas Ferre (1):
      at91: at91sam9g20ek modify dual slot evaluation kit

This will align code with real at91sam9g20 Evaluation Kit from Atmel. The 
current one is not usable with the official revision of the board. This is 
why I propose it for .32-final.

Here are the stats for this commit:

 arch/arm/mach-at91/Kconfig                     |   20 +++++++++++---------
 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c |   23 +++++++++++++++--------
 2 files changed, 26 insertions(+), 17 deletions(-)

Thanks,

-- 
Nicolas Ferre


