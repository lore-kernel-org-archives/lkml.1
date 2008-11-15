Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYKOXep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYKOXep (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 18:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYKOXeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 18:34:37 -0500
Received: from isilmar.linta.de ([213.133.102.198]:32772 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751420AbYKOXeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 18:34:36 -0500
Date: Sun, 16 Nov 2008 00:34:29 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pcmcia@lists.infradead.org
Subject: [git pull] PCMCIA updates and fixes for 2.6.28-rc5
Message-ID: <20081115233429.GA818@isilmar.linta.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-pcmcia@lists.infradead.org
References: <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0811151444090.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

unforutnately, lkml seems to have eaten my PCMCIA pull query for -rc4 -- at
least no lkml archive seems to have picked it up, while the linux-pcmcia one
did:
http://lists.infradead.org/pipermail/linux-pcmcia/2008-November/006008.html

Anyways, a few PCMCIA bugfixes are available at

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

The diffstat and list of changes follows, the individual diffs were sent (at
least) to the linux-pcmcia list.

Thanks,
        Dominik

----

Dominik Brodowski (2):
      pcmcia: add braces in error path
      pcmcia: ensure correct logging in do_io_probe

Ilpo Järvinen (1):
      pcmcia: fix indentation & braces disagreement - add braces

Kay Sievers (1):
      pcmcia: struct device - replace bus_id with dev_name(), dev_set_name()

Komuro (1):
      pcmcia: setup resource information for pseudo multifunction devices.

Marc Pignat (1):
      pcmcia: add another pata/ide ID

 drivers/ata/pata_pcmcia.c        |    1 +
 drivers/ide/ide-cs.c             |    1 +
 drivers/pcmcia/cistpl.c          |    3 ++-
 drivers/pcmcia/cs.c              |   14 +++++++-------
 drivers/pcmcia/ds.c              |   11 ++++++-----
 drivers/pcmcia/pcmcia_resource.c |    3 ++-
 drivers/pcmcia/rsrc_nonstatic.c  |    6 +++---
 7 files changed, 22 insertions(+), 17 deletions(-)
