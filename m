Return-Path: <linux-kernel-owner+w=401wt.eu-S933889AbXKPSsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889AbXKPSsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXKPSsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:48:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38235 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbXKPSsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:48:15 -0500
Date: Fri, 16 Nov 2007 10:47:21 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.5
Message-ID: <20071116184721.GI9807@kroah.com>
References: <20071116183752.GA9807@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116183752.GA9807@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.5 kernel.
It contains a number of bugfixes for networking drivers.

I'll also be replying to this message with a copy of the patch between
2.6.23.4 and 2.6.23.5

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                               |    2 
 drivers/net/ehea/ehea_qmr.c            |   20 ++-----
 drivers/net/ehea/ehea_qmr.h            |    2 
 drivers/net/forcedeth.c                |   35 +++++++++---
 drivers/net/pppol2tp.c                 |   25 ++++++---
 drivers/net/skge.c                     |   90 +++++++++++++++++----------------
 drivers/net/skge.h                     |    6 --
 drivers/net/sky2.c                     |   87 +++++++++++++++++++++++++------
 drivers/net/tg3.c                      |   10 ++-
 drivers/net/wireless/ipw2100.c         |   39 ++++++++++++++
 drivers/net/wireless/ipw2100.h         |    4 +
 drivers/net/wireless/libertas/11d.c    |    2 
 drivers/net/wireless/libertas/cmd.c    |    6 --
 drivers/net/wireless/libertas/wext.c   |    8 +-
 drivers/net/wireless/rtl8187_dev.c     |   31 +++++------
 drivers/net/wireless/zd1201.c          |    4 -
 drivers/net/wireless/zd1211rw/zd_usb.c |    7 +-
 include/linux/pci_ids.h                |    4 +
 18 files changed, 260 insertions(+), 122 deletions(-)

Summary of changes from v2.6.23.4 to v2.6.23.5
==============================================

Al Viro (2):
      libertas: more endianness breakage
      libertas: fix endianness breakage

Ayaz Abdulla (1):
      forcedeth: add MCP77 device IDs

Dan Williams (1):
      ipw2100: send WEXT scan events

Greg Kroah-Hartman (1):
      Linux 2.6.23.5

James Chapman (1):
      Fix L2TP oopses.

Jan-Bernd Themann (1):
      ehea: 64K page kernel support fix

John W. Linville (1):
      zd1201: avoid null ptr access of skb->dev

Manfred Spraul (1):
      forcedeth msi bugfix

Marc Pignat (1):
      zd1211rw, fix oops when ejecting install media

Michael Chan (1):
      TG3: Fix performance regression on 5705.

Michael Wu (1):
      rtl8187: Fix more frag bit checking, rts duration calc

Stephen Hemminger (4):
      skge: XM PHY handling fixes
      sky2: status ring race fix
      sky2: ethtool register reserved area blackout
      sky2: fix power settings on Yukon XL

