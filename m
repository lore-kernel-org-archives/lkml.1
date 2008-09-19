Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYISTKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYISTKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 15:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYISTJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 15:09:53 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:39980 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbYISTJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 15:09:52 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, kernel@avr32linux.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 0/4] atmel-mci: fixes for 2.6.27
Date: Fri, 19 Sep 2008 21:09:26 +0200
Message-Id: <1221851370-20189-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 19 Sep 2008 19:09:20.0196 (UTC) FILETIME=[382C1840:01C91A8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Here is a small handful of fixes for problems I've found while testing
the new atmel-mci driver. I hope they can be applied before 2.6.27
goes out the door.

I guess it's too late to add DMA support at this point, so I'll post
that separately along with a few other improvements.

Haavard Skinnemoen (4):
      atmel-mci: debugfs: enable clock before dumping regs
      atmel-mci: Fix memory leak in atmci_regs_show
      atmel-mci: Fix bogus debugfs file size
      atmel-mci: Set MMC_CAP_NEEDS_POLL if no detect_pin

 drivers/mmc/host/atmel-mci.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

Haavard
