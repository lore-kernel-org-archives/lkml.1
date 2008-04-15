Return-Path: <linux-kernel-owner+w=401wt.eu-S1765071AbYDOOpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765071AbYDOOpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759583AbYDOOpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:45:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49882 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758462AbYDOOph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:45:37 -0400
Date: Tue, 15 Apr 2008 15:45:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, Dmitry Torokhov <dtor@mail.ru>,
       Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: WM97xx touchscreen updates
Message-ID: <20080415144535.GA20619@rakim.wolfsonmicro.main>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	David Brownell <david-b@pacbell.net>,
	Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series updates the WM97xx touchscreen drivers with a couple
of small cleanups and the addition of support for use of the WM97xx
touchpanels to wake up from suspend.  Since the last submission I have:

 - Updated the commit message for scheduling of the interrupt handler. 
 - Hooked the touchscreen into the driver model wakeup infrastructure.

It is also available in the git repository at:

  git://opensource.wolfsonmicro.com/linux-2.6-touch upstream

Mark Brown (3):
      wm97xx-core: Only schedule interrupt handler if not already scheduled
      wm97xx-core: Use IRQF_SAMPLE_RANDOM
      wm97xx-core: Support use as a wakeup source

 drivers/input/touchscreen/wm97xx-core.c |   56 ++++++++++++++++++++++++++----
 include/linux/wm97xx.h                  |    3 ++
 2 files changed, 51 insertions(+), 8 deletions(-)
