Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbYJMSUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbYJMSUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758580AbYJMSUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:20:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:40989 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558AbYJMSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:20:18 -0400
Date: Mon, 13 Oct 2008 14:20:20 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: please pull the reduced fastboot tree
Message-ID: <20081013142020.22b970cc@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

can you pull the "for-linus" branch of my fastboot tree (full git line below)?
It has the pieces of the fastboot tree that are independent of the asynchronous
stuff, and is generally useful:
* The boot visualisation script
* Making RAID autodetect a config option (acked by NeilB)



The following changes since commit f1b2a5ace996de339292d4035f9f5b294aecd11e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../sfrench/cifs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-fastboot.git for-linus

Alan Jenkins (1):
      raid, fastboot: hide RAID autodetect option if MD is compiled as a module

Arjan van de Ven (5):
      Add a script to visualize the kernel boot process / time
      fastboot: fix issues and improve output of bootgraph.pl
      fastboot: make the raid autodetect code wait for all devices to init
      fastboot: make the RAID autostart code print a message just before waiting
      raid: make RAID autodetect default a KConfig option

Arnaud Patard (1):
      fastboot: Fix bootgraph.pl initcall name regexp

Ingo Molnar (1):
      warning: fix init do_mounts_md c

 drivers/md/Kconfig   |   14 +++++
 init/do_mounts_md.c  |   40 +++++++++++---
 init/main.c          |    2 +-
 scripts/bootgraph.pl |  147 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 193 insertions(+), 10 deletions(-)
 create mode 100644 scripts/bootgraph.pl


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
