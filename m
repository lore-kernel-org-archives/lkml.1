Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbZAHGRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbZAHGRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZAHGRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:17:22 -0500
Received: from 076-076-148-181.pdx.net ([76.76.148.181]:35214 "EHLO gocho"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752089AbZAHGRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:17:21 -0500
X-Greylist: delayed 46703 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 01:17:21 EST
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: netdev@vger.kernel.org
Cc: wimax@linuxwimax.org, greg@kroah.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: [PATCH 0/3] wimax: Kbuild / rfkill-build fixes (v2)
Date: Wed,  7 Jan 2009 09:18:44 -0800
Message-Id: <cover.1231348339.git.inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches fix issues reported by Randy Dunlap on the
linux-next tree for Jan 6:

http://lkml.org/lkml/2009/1/6/340

The issue fixed by patch #3 wasn't reported on the emails but was
uncovered while discussing the fixes.

This applies to the wimax tree kept in gregkh's repository:

http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/

Changes in v2

- fixed silly one-char typo #ifndef CONFIG_BUG vs #ifdef CONFIG_BUG
  reported by Ilpo Järvinen 

Inaky Perez-Gonzalez (3):
  wimax: fix '#ifndef CONFIG_BUG' layout to avoid warning
  wimax: fix kconfig interactions with rfkill and input layers
  wimax: testing for rfkill support should also test for
    CONFIG_RFKILL_MODULE

 net/wimax/Kconfig     |   14 ++++++++++++++
 net/wimax/id-table.c  |    8 +++++---
 net/wimax/op-rfkill.c |    2 +-
 3 files changed, 20 insertions(+), 4 deletions(-)

