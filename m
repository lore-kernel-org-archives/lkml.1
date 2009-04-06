Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbZDFPtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbZDFPtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZDFPsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:48:54 -0400
Received: from mga12.intel.com ([143.182.124.36]:43904 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754562AbZDFPsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:48:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,331,1235980800"; 
   d="scan'208";a="128369190"
Subject: [GIT PULL] Backlight updates for 2.6.30
From: Richard Purdie <rpurdie@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 16:49:28 +0100
Message-Id: <1239032968.5323.56.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree updates for 2.6.30. The contents is two new
drivers, an extension for new hardware for an existing driver and a
driver tweak. These have all been in -next/-mm for a while.

Thanks, Richard

 drivers/video/backlight/Kconfig          |   18 ++
 drivers/video/backlight/Makefile         |    2 
 drivers/video/backlight/jornada720_bl.c  |  161 ++++++++++++++++++++++++++
 drivers/video/backlight/jornada720_lcd.c |  153 ++++++++++++++++++++++++
 drivers/video/backlight/mbp_nvidia_bl.c  |  191 +++++++++++++++++++++++++------
 drivers/video/backlight/pwm_bl.c         |    4 
 6 files changed, 491 insertions(+), 38 deletions(-)

Eric Miao (1):
      backlight: fix pwm_bl.c when multiple PWM backlights exist

Kristoffer Ericson (2):
      backlight: Add HP Jornada 700 series LCD driver
      backlight: Adds HP Jornada 700 series backlight driver

Mario Schwalbe (2):
      backlight: Add support for MacBook 5, MacBook Air 2, and MacBook Pro 5
      backlight: mbp_nvidia_bl - Add a debug switch



