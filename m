Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYANGB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYANGB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 01:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYANGBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 01:01:51 -0500
Received: from mxsf08.insightbb.com ([74.128.0.78]:16710 "EHLO
	mxsf08.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYANGBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 01:01:50 -0500
X-IronPort-AV: E=Sophos;i="4.24,280,1196658000"; 
   d="scan'208";a="204794614"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACSKikdKjlCP/2dsb2JhbACBVpAGlRA
X-IronPort-AV: E=Sophos;i="4.24,280,1196658000"; 
   d="scan'208";a="185896324"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.24-rc3
Date: Mon, 14 Jan 2008 01:01:46 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801140101.47144.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Dmitry Baryshkov (1):
      Input: Handle EV_PWR type of input caps in input_set_capability.

Ivan Kokshaysky (1):
      gameport: don't export functions that are static inline

Kristoffer Ericson (2):
      Input: jornada680_kbd - fix default keymap
      Input: improve Kconfig help entries for HP Jornada devices

Richard Purdie (2):
      Input: spitzkbd - fix suspend key handling
      Input: pass EV_PWR events to event handlers


Diffstat:
--------

 drivers/input/gameport/gameport.c       |    2 -
 drivers/input/input.c                   |    8 ++++++
 drivers/input/keyboard/Kconfig          |   12 ++++----
 drivers/input/keyboard/jornada680_kbd.c |   40 +++++++++++++++---------------
 drivers/input/keyboard/spitzkbd.c       |    1 +
 drivers/input/touchscreen/Kconfig       |    8 ++----
 6 files changed, 38 insertions(+), 33 deletions(-)

-- 
Dmitry
