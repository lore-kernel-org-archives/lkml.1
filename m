Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZI1W5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZI1W5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZI1W5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:57:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38955 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbZI1W5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:57:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fixes for 2.6.32
Date: Tue, 29 Sep 2009 00:58:20 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, stable@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909290058.20509.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

This removes the redundant second argument of pcmcia_socket_dev_suspend()
and, on top of that, fixes CardBus suspend/resume that has been broken
since 2.6.29.

 drivers/pcmcia/at91_cf.c        |    2 +-
 drivers/pcmcia/au1000_generic.c |    2 +-
 drivers/pcmcia/bfin_cf_pcmcia.c |    2 +-
 drivers/pcmcia/cs.c             |    2 +-
 drivers/pcmcia/i82092.c         |    2 +-
 drivers/pcmcia/i82365.c         |    2 +-
 drivers/pcmcia/m32r_cfc.c       |    2 +-
 drivers/pcmcia/m32r_pcc.c       |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c    |    2 +-
 drivers/pcmcia/omap_cf.c        |    2 +-
 drivers/pcmcia/pd6729.c         |    2 +-
 drivers/pcmcia/pxa2xx_base.c    |    2 +-
 drivers/pcmcia/sa1100_generic.c |    2 +-
 drivers/pcmcia/sa1111_generic.c |    2 +-
 drivers/pcmcia/tcic.c           |    2 +-
 drivers/pcmcia/vrc4171_card.c   |    2 +-
 drivers/pcmcia/yenta_socket.c   |   88 +++++++++++++++++++++------------------
 include/pcmcia/ss.h             |    2 +-
 18 files changed, 65 insertions(+), 57 deletions(-)

---------------

Rafael J. Wysocki (2):
      PM / PCMCIA: Drop second argument of pcmcia_socket_dev_suspend()
      PM / yenta: Fix cardbus suspend/resume regression

