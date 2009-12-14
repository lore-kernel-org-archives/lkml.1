Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZLNTAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZLNTAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757046AbZLNTAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:00:00 -0500
Received: from isilmar.linta.de ([213.133.102.198]:42530 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756912AbZLNTAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:00:00 -0500
Date: Mon, 14 Dec 2009 19:55:30 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [git pull] PCMCIA updates for 2.6.33, part 2
Message-ID: <20091214185530.GA24593@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, alsa-devel@alsa-project.org
References: <20091024082400.GA28377@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091024082400.GA28377@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

two more PCMCIA updates for 2.6.33 are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

Please pull from that location. The diffstat and list of changes is below,
the two patches will be sent (at least) to the linux-pcmcia list.

Thanks,
        Dominik

----
The following changes since commit f40542532e96dda5506eb76badea322f2ae4731c:
  Linus Torvalds (1):
        Merge branch 'ixp4xx' of git://git.kernel.org/.../chris/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

Dominik Brodowski (2):
      pcmcia: remove unused IRQ_FIRST_SHARED
      pcmcia: CodingStyle fixes

 drivers/isdn/hardware/avm/avm_cs.c |    3 +-
 drivers/isdn/hisax/avma1_cs.c      |    3 +-
 drivers/isdn/hisax/elsa_cs.c       |    2 +-
 drivers/isdn/hisax/sedlbauer_cs.c  |    2 +-
 drivers/isdn/hisax/teles_cs.c      |    2 +-
 drivers/net/pcmcia/axnet_cs.c      |    2 +-
 drivers/net/pcmcia/fmvj18x_cs.c    |    2 +-
 drivers/net/pcmcia/pcnet_cs.c      |    2 +-
 drivers/net/pcmcia/smc91c92_cs.c   |    2 +-
 drivers/net/pcmcia/xirc2ps_cs.c    |    2 +-
 drivers/pcmcia/Kconfig             |    6 +-
 drivers/pcmcia/cardbus.c           |   23 ++--
 drivers/pcmcia/cistpl.c            |  181 ++++++++++++--------
 drivers/pcmcia/cs.c                |   12 +-
 drivers/pcmcia/ds.c                |   66 ++++----
 drivers/pcmcia/pcmcia_ioctl.c      |   45 +++---
 drivers/pcmcia/pcmcia_resource.c   |   37 +++--
 drivers/pcmcia/rsrc_mgr.c          |   14 +-
 drivers/pcmcia/rsrc_nonstatic.c    |  325 ++++++++++++++++++-----------------
 drivers/pcmcia/socket_sysfs.c      |    6 +-
 drivers/pcmcia/yenta_socket.c      |  147 +++++++++++------
 include/pcmcia/cs.h                |    4 +-
 include/pcmcia/ds.h                |    6 +-
 include/pcmcia/mem_op.h            |    2 +-
 include/pcmcia/ss.h                |   12 +-
 sound/pcmcia/pdaudiocf/pdaudiocf.c |    3 +-
 26 files changed, 504 insertions(+), 407 deletions(-)
