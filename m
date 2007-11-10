Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbXKJIHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbXKJIHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 03:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbXKJIHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 03:07:01 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:59869 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751490AbXKJIHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 03:07:00 -0500
Date: Sat, 10 Nov 2007 17:06:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Robert Schwebel <robert@schwebel.de>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: ARM defconfig bogosity in current git
Message-ID: <20071110080629.GA18520@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Robert Schwebel <robert@schwebel.de>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The last ARM merge contained this gem:

commit f33bac8dd4573428b94c67149c5607be489092d1
Author: Robert Schwebel <robert@schwebel.de>
Date:   Mon Nov 5 17:59:25 2007 +0100

    [ARM] 4642/2: netX: default config for netx based boards
    
    This patch updates the default config file for netx based boards.
    
    Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
    Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/arm/configs/netx_defconfig b/arm/configs/netx_defconfig
new file mode 100644
index 0000000..57f32f3
--- /dev/null
+++ b/arm/configs/netx_defconfig

...

Isn't there something in Documentation/ about -p1 being a good idea
precisely so this sort of silliness is avoided?

Currently this breaks tab completion on arch/, which is very much a
regression ;-)
