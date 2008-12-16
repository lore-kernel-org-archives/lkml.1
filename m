Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYLPHuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYLPHuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbYLPHuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:50:05 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:37695 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751165AbYLPHuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:50:04 -0500
Date: Tue, 16 Dec 2008 16:48:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.28-rc9
Message-ID: <20081216074812.GA27933@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Dreamcast port hadn't been tested in some time, so a couple of bugs
fell out in recent testing. So, here are some last minute fixes to get
the Dreamcast working again.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.28

Which contains:

Matt Fleming (1):
      sh: maple: Do not pass SLAB_POISON to kmem_cache_create()

Paul Mundt (1):
      sh: Disable GENERIC_HARDIRQS_NO__DO_IRQ for unconverted platforms.

 arch/sh/Kconfig          |    2 ++
 drivers/sh/maple/maple.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)
