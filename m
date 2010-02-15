Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0BOPJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:09:44 -0500
Received: from sh.osrg.net ([192.16.179.4]:38224 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab0BOPJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:09:43 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net
Subject: [PATCH -mm v2 0/5] ssb: replace the ssb_dma API with the generic DMA API
Date: Tue, 16 Feb 2010 00:04:05 +0900
Message-Id: <1266246250-5344-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 16 Feb 2010 00:09:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that there is a good chance of the inclusion so here's the
second version that finishes all the conversion.


=
 drivers/net/b44.c                    |  144 +++++++++++++++----------------
 drivers/net/wireless/b43/dma.c       |   65 +++++++-------
 drivers/net/wireless/b43legacy/dma.c |   49 ++++++-----
 drivers/ssb/main.c                   |   76 +----------------
 include/linux/ssb/ssb.h              |  159 +---------------------------------
 5 files changed, 133 insertions(+), 360 deletions(-)
