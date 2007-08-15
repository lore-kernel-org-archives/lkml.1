Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbXHOSdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbXHOSdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 14:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbXHOSdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 14:33:00 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53846 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbXHOSc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 14:32:59 -0400
Date: Wed, 15 Aug 2007 11:31:38 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.22.3
Message-ID: <20070815183138.GA11251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.22.3 kernel.
This release has a few bugfixes so all users of the 2.6.22 series are
encouraged to update to it.  Especially people with laptops, they will
appreciate the power savings in this release.

I'll also be replying to this message with a copy of the patch between
2.6.22.2 and 2.6.22.3

The updated 2.6.22.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.22.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                                    |    2 -
 arch/powerpc/kernel/prom_parse.c            |    2 -
 arch/powerpc/mm/slice.c                     |    2 +
 arch/powerpc/platforms/83xx/mpc832x_mds.c   |    1 
 arch/powerpc/platforms/83xx/mpc832x_rdb.c   |    1 
 arch/powerpc/platforms/83xx/mpc836x_mds.c   |    1 
 arch/powerpc/platforms/85xx/mpc85xx_mds.c   |    1 
 drivers/ata/ata_piix.c                      |    2 -
 drivers/ata/pata_atiixp.c                   |    1 
 drivers/char/random.c                       |    9 ++++++--
 drivers/cpufreq/cpufreq_ondemand.c          |   30 +++++++++++++++++++---------
 drivers/video/stifb.c                       |   19 +++++++++++------
 fs/direct-io.c                              |    1 
 kernel/auditsc.c                            |   22 ++++++++++----------
 net/ieee80211/softmac/ieee80211softmac_wx.c |   11 +++++++---
 15 files changed, 66 insertions(+), 39 deletions(-)

Summary of changes from v2.6.22.2 to v2.6.22.3
============================================

Al Viro (1):
      fix oops in __audit_signal_info()

Badari Pulavarty (1):
      direct-io: fix error-path crashes

Benjamin Herrenschmidt (1):
      powerpc: Fix size check for hugetlbfs

Greg Kroah-Hartman (1):
      Linux 2.6.22.3

Helge Deller (1):
      stifb: detect cards in double buffer mode more reliably

Jeff Garzik (1):
      pata_atiixp: add SB700 PCI ID

Kim Phillips (1):
      PPC: Revert "[POWERPC] Add 'mdio' to bus scan id list for platforms with QE UEC"

Matt Mackall (1):
      random: fix bound check ordering (CVE-2007-3105)

Michael Buesch (1):
      softmac: Fix deadlock of wx_set_essid with assoc work

Paul Mackerras (1):
      PPC: Revert "[POWERPC] Don't complain if size-cells == 0 in prom_parse()"

Tejun Heo (1):
      ata_piix: update map 10b for ich8m

Venki Pallipadi (2):
      CPUFREQ: ondemand: fix tickless accounting and software coordination bug
      CPUFREQ: ondemand: add a check to avoid negative load calculation

