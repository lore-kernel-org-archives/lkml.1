Return-Path: <linux-kernel-owner+w=401wt.eu-S1757816AbYBHNR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816AbYBHNR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 08:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbYBHNRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 08:17:20 -0500
Received: from bb-87-81-255-5.ukonline.co.uk ([87.81.255.5]:52281 "EHLO
	pegasus." rhost-flags-OK-OK-FAIL-FAIL) by vger.kernel.org with ESMTP
	id S1752047AbYBHNRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 08:17:19 -0500
X-Greylist: delayed 1791 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2008 08:17:18 EST
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] x86 - Move laptop drivers out of x86 Kconfig
To: linux-kernel@vger.kernel.org
Date: Fri, 08 Feb 2008 12:47:21 +0000
Message-ID: <20080208124721.16369.76502.stgit@localhost>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series moves the two laptop drivers from x86 Kconfig (i8k
and toshiba) to drivers/char, which is where the source for them lives anyway.

Given they are not x86 processor features, the x86 Kconfig menu is not really
an appropriate place for them to live.

This is against Linus latest tree, since x86 git seems to be missing an
earlier Kconfig patch for I8K that dropped the x86_32 limitation.

-Carlos
---

Carlos Corbacho (2):
      toshiba - Move Kconfig entry to drivers/char
      i8k - Move Kconfig entry to drivers/char


 arch/x86/Kconfig     |   36 ------------------------------------
 drivers/char/Kconfig |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 36 deletions(-)

-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
