Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbYJ2Av1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbYJ2Av1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 20:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYJ2AvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 20:51:18 -0400
Received: from isilmar.linta.de ([213.133.102.198]:52766 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753314AbYJ2AvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 20:51:18 -0400
Date: Wed, 29 Oct 2008 01:47:32 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       alan@redhat.com
Subject: [git pull] PCMCIA updates and fixes for 2.6.28-rc2
Message-ID: <20081029004732.GA20290@comet.dominikbrodowski.net>
Mail-Followup-To: torvalds@osdl.org, akpm@osdl.org,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	alan@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

a few PCMCIA bugfixes from Alan are available at

  git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git master

The diffstat and list of changes follows, the individual diffs are sent (at
least) to the linux-pcmcia list.

Thanks,
	Dominik

----

Alan Cox (3):
      pcmcia: IRQ_TYPE_EXCLUSIVE is long obsoleted
      pcmcia: Whine harder about use of EXCLUSIVE
      fdomain_cs: Sort out modules with duplicate description

 drivers/bluetooth/bluecard_cs.c   |    2 +-
 drivers/bluetooth/bt3c_cs.c       |    6 ++++--
 drivers/bluetooth/btuart_cs.c     |    6 ++++--
 drivers/bluetooth/dtl1_cs.c       |    7 +++++--
 drivers/char/pcmcia/synclink_cs.c |    2 +-
 drivers/parport/parport_cs.c      |    2 +-
 drivers/pcmcia/pcmcia_resource.c  |    3 ++-
 drivers/scsi/fdomain.c            |    2 ++
 8 files changed, 20 insertions(+), 10 deletions(-)
