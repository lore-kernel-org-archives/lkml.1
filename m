Return-Path: <linux-kernel-owner+w=401wt.eu-S1765016AbXF2Frw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765016AbXF2Frw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXF2Frp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:47:45 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:16791 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXF2Fro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:47:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAO85hEZKhRO4R2dsb2JhbACPIgEBGw0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.22-rc4
Date: Fri, 29 Jun 2007 01:47:40 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706290147.41364.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem. Note that the bulk of changes to
input.h are just comments for various KEY_XXX input codes and not functional
changes.

Changelog:
----------

Dmitry Torokhov (4):
      Input: i8042 - add HP Pavilion ZT1000 to the MUX blacklist
      Input: atkbd - throttle LED switching
      Input: serio - take drv_mutex in serio_cleanup()
      Input: document some of keycodes

Henrique de Moraes Holschuh (1):
      Input: add a new EV_SW SW_RADIO event, for radio switches on laptops

Qi Yong (1):
      Input: atkbd - use printk_ratelimit for spurious ACK messages

Diffstat:
---------

 drivers/input/keyboard/atkbd.c        |   47 +++++++----
 drivers/input/serio/i8042-x86ia64io.h |   11 +++
 drivers/input/serio/serio.c           |    2 +
 include/linux/input.h                 |  143 +++++++++++++++++---------------
 4 files changed, 119 insertions(+), 84 deletions(-)

-- 
Dmitry
