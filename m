Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZJEVPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZJEVPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZJEVPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:15:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55037 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091AbZJEVP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:15:27 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 0/3] misc mtd patches for 2.6.32
Date: Mon,  5 Oct 2009 17:14:46 -0400
Message-Id: <1254777289-32109-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David picked up the rest of my patches, but here's some that didn't make
it into his merge for 2.6.32.  The SST isn't critical, but it'd be nice
to have.  The gpio-addr-flash ones fix build errors in randconfig setups
as reported by some people due to missing depends/incomplete includes.

These can also be found in my 'for-mtd' branch in my Blackfin repo:
	git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-mtd

Graf Yang (1):
  mtd: m25p80: disable SST software protection bits by default

Mike Frysinger (2):
  mtd/maps: gpio-addr-flash: pull in linux/ headers rather than asm/
  mtd/maps: gpio-addr-flash: depend on GPIO arch support

 drivers/mtd/devices/m25p80.c       |    7 ++++---
 drivers/mtd/maps/Kconfig           |    1 +
 drivers/mtd/maps/gpio-addr-flash.c |    5 ++---
 3 files changed, 7 insertions(+), 6 deletions(-)

