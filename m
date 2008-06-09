Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYFIGfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYFIGfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 02:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYFIGfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 02:35:25 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:36096 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbYFIGfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 02:35:24 -0400
Date: Mon, 9 Jun 2008 08:35:21 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] au1xmmc updates #4
Message-ID: <20080609063521.GA8724@roarinelk.homelinux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The following set of patches updates the au1xmmc driver with new features
and moves code not belonging to the driver source to MIPS/Alchemy board
files.

I also took the opportunity to clean up the drivers probe() and irq()
handlers to make it a "proper" platform device (patches #1 and #2).

Patches #3, #4 and #6 implement new features, #5 and #7 are cleanups.

The patches are intended to be applied on top of each other, against
current mainline git (2.6.23-rc5+).

Changes since V3:
- previous patches #1 and #2 are dropped since they are already upstream.
  ("Alchemy: export get_au1x00_speed for modules" and
   "Alchemy: dbdma: add API to delete custom DDMA device")

- few additional minor fixes and patches folded into others.

- I'm taking over maintainership of the driver for as long as I have
  hardware to test it on.

Changes since V2:
- address almost all Sergei Shtylyov's comments:
  pb1200/db1200 mmc device registration moved back to original location,
  remove the au1xmmc.h header as part of codingstyle cleanup
  other nits.

- 2 more patches (#8, #9)

Changes since V1:
- fix a bug in patch #6: SDIO irq should be checked for independently
  from other irq events.
- more trivial cleanups

Db1200 users, please test!  I verified the poll timer works on one of
older boards, however since I don't have Db1200 and Pb1200 boards I'm
not sure whether the driver still works with both SD controllers enabled!

Thanks!
	Manuel Lauss
