Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZG1Lu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZG1Lu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 07:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZG1Lu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 07:50:26 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:36014 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbZG1LuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:50:25 -0400
Message-Id: <cover.1248781021.git.keil@b1-systems.de>
Date: Tue, 28 Jul 2009 13:37:01 +0200
Subject: [PATCH 0/1] mISDN: Fix handling of receive buffer size in L1oIP
From: Karsten Keil <keil@b1-systems.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, i4ldeveloper@listserv.isdn4linux.de,
       Andreas Eversberg <andreas@eversberg.eu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a regression introduced in 2.6.31 with the commit
8c90e11e3543d7de612194a042a148caeaab5f1d "mISDN: Use kernel_{send,recv}msg instead of open coding".

Linus: you can pull the fix from
git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6-net-next for_linus

David for net-next-2.6 you can get it from:
git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6-net-next for_david

Andreas Eversberg (1):
  mISDN: Fix handling of receive buffer size in L1oIP

 drivers/isdn/mISDN/l1oip_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

