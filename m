Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbZIOTHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbZIOTHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbZIOTHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:07:42 -0400
Received: from kroah.org ([198.145.64.141]:35821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337AbZIOTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:07:25 -0400
Date: Tue, 15 Sep 2009 11:21:49 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [GIT PATCH] PCMCIA patches for 2.6.31-git
Message-ID: <20090915182149.GA32264@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the PCMCIA patchset for the 2.6.31 merge window

Due to the current maintainer being busy, I got tagged to send these to
you :)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pcmcia-2.6.git/

The patches will be sent as a follow-on to this message to the
linux-pcmcia for people to see.

thanks,

greg k-h

------------

 drivers/bluetooth/dtl1_cs.c      |    2 +-
 drivers/pcmcia/au1000_pb1x00.c   |    1 -
 drivers/pcmcia/au1000_xxs1500.c  |    1 -
 drivers/pcmcia/ds.c              |    3 +--
 drivers/pcmcia/o2micro.h         |    4 ++++
 drivers/pcmcia/pcmcia_ioctl.c    |    2 +-
 drivers/pcmcia/pcmcia_resource.c |    6 +++---
 include/pcmcia/ss.h              |    4 ++--
 8 files changed, 12 insertions(+), 11 deletions(-)

---------------

Joe Perches (1):
      pcmcia: drivers/pcmcia/pcmcia_resource.c: Remove unnecessary semicolons

Philipp Zabel (1):
      pcmcia: dtl1_cs: fix pcmcia_loop_config logic

Roel Kluin (1):
      pcmcia: drivers/pcmcia: Make static

Steven A. Falco (1):
      pcmcia: Use phys_addr_t for physical addresses

Tomas Kovacik (1):
      pcmcia: disable prefetch/burst for OZ6933

Wolfram Sang (3):
      pcmcia: fix incorrect argument order to list_add_tail()
      pcmcia: drop non-existant includes
      pcmcia: document return value of pcmcia_loop_config

