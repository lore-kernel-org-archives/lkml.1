Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbZJXTZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbZJXTZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 15:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZJXTZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 15:25:30 -0400
Received: from isilmar.linta.de ([213.133.102.198]:52931 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751819AbZJXTZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 15:25:30 -0400
Date: Sat, 24 Oct 2009 21:25:24 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [git pull - v2] PCMCIA fixes for 2.6.32
Message-ID: <20091024192524.GA18016@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20091024082400.GA28377@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091024082400.GA28377@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ update: patch "pcmcia: do not load the pd6729 driver if io_base is NULL"
  now checks for NULL and does not do any castings. Thanks to Wolfram Sang
  for noticing this issue. ]

Linus,

some PCMCIA bugfixes for 2.6.32 are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6/ urgent-v2

Please pull from that location. The diffstat and list of changes follows,
the individual diffs are sent (at least) to the linux-pcmcia list.

Thanks,
        Dominik

----

Dominik Brodowski (2):
      pcmcia: pccard_read_tuple and TUPLE_RETURN_COMMON cleanup
      pcmcia: do not try to store more than 4 version strings

Frans Pop (1):
      pcmcia: properly close previous dev_printk if kzalloc fails in do_io_probe

Komuro (1):
      pcmcia: do not load the pd6729 driver if io_base is NULL

Randy Dunlap (1):
      pcmcia: fix controller printk format warnings

Wolfram Sang (1):
      pcmcia: Fix possible printk format warnings

----

 drivers/pcmcia/cistpl.c         |   20 +++++++++++---------
 drivers/pcmcia/cs_internal.h    |    3 +--
 drivers/pcmcia/ds.c             |    8 ++++----
 drivers/pcmcia/i82365.c         |    4 ++--
 drivers/pcmcia/m32r_cfc.c       |   10 ++++++----
 drivers/pcmcia/m32r_pcc.c       |   10 ++++++----
 drivers/pcmcia/m8xx_pcmcia.c    |   15 +++++++++------
 drivers/pcmcia/pcmcia_ioctl.c   |    2 +-
 drivers/pcmcia/pd6729.c         |    6 ++++++
 drivers/pcmcia/rsrc_nonstatic.c |    3 ++-
 drivers/pcmcia/soc_common.c     |    5 +++--
 drivers/pcmcia/socket_sysfs.c   |    2 +-
 drivers/pcmcia/tcic.c           |    4 ++--
 13 files changed, 54 insertions(+), 38 deletions(-)
