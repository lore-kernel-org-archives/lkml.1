Return-Path: <linux-kernel-owner+w=401wt.eu-S1753867AbZH3TvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbZH3TvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 15:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZH3TvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 15:51:02 -0400
Received: from poutre.nerim.net ([62.4.16.124]:55573 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbZH3TvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 15:51:01 -0400
Date: Sun, 30 Aug 2009 21:50:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Petr Vandrovec <vandrove@vc.cvut.cz>
Subject: [PATCH 0/5] matroxfb: Code cleanups
Message-ID: <20090830215059.0fae63c3@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, Andrew,

This is a 5-piece patchset cleaning up the matroxfb driver:

[PATCH 1/5] matroxfb: Make CONFIG_FB_MATROX_MULTIHEAD=y mandatory
[PATCH 2/5] matroxfb: Get rid of unneeded macros ACCESS_FBINFO and MINFO
[PATCH 3/5] matroxfb: Get rid of unneeded macros WPMINFO and friends
[PATCH 4/5] matroxfb: Get rid of unneeded macro MINFO_FROM
[PATCH 5/5] matroxfb: Get rid of CONFIG_FB_MATROX_32MB

 Documentation/fb/matroxfb.txt           |    4 
 drivers/video/Kconfig                   |   20 
 drivers/video/matrox/g450_pll.c         |  209 ++++----
 drivers/video/matrox/g450_pll.h         |    8 
 drivers/video/matrox/i2c-matroxfb.c     |   18 
 drivers/video/matrox/matroxfb_DAC1064.c |  616 +++++++++++++------------
 drivers/video/matrox/matroxfb_DAC1064.h |    4 
 drivers/video/matrox/matroxfb_Ti3026.c  |  260 +++++-----
 drivers/video/matrox/matroxfb_accel.c   |  129 ++---
 drivers/video/matrox/matroxfb_accel.h   |    2 
 drivers/video/matrox/matroxfb_base.c    |  770 +++++++++++++++-----------------
 drivers/video/matrox/matroxfb_base.h    |   80 ---
 drivers/video/matrox/matroxfb_crtc2.c   |  160 +++---
 drivers/video/matrox/matroxfb_g450.c    |  185 ++++---
 drivers/video/matrox/matroxfb_g450.h    |    8 
 drivers/video/matrox/matroxfb_maven.c   |   48 +
 drivers/video/matrox/matroxfb_misc.c    |  296 ++++++------
 drivers/video/matrox/matroxfb_misc.h    |   15 
 18 files changed, 1436 insertions(+), 1396 deletions(-)

The diffstat is impressive, but that's really only mecanical changes
being applied driver-wide. There's no actual code change and there
should be zero runtime difference before and after the patchset. I've
tested it on my Millennium to make sure.

Andrew, can you please pick these patches and push them to Linus for
2.6.32? Thanks.

-- 
Jean Delvare
