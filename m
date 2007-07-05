Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbXGEFLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbXGEFLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 01:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXGEFLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 01:11:42 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:17317 "EHLO
	asav09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbXGEFLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 01:11:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRADwPjEZKhRO4R2dsb2JhbACPIAEBGw0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull][resend] Input updates for 2.6.22-rc7
Date: Thu, 5 Jul 2007 01:11:42 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707050111.43327.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending with proper kernel version in subject... I guess original claiming
to be for 2.6.22-rc4 might have something to do with it being dropped...]

Hi Linus,

Please consider pulling from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem. You will get update to AT keyboard
driver that throttles LED switching so that 'setleds' does not lock up
keyboards. Also fix for an oops happening if user presses Ctrl-Alt-Del in
the middle of keyboard being probed (serio_cleanup should take mutex).
Note that the bulk of changes to input.h are just comments for various
KEY_XXX input codes and not functional changes.

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

 drivers/input/keyboard/atkbd.c        |   47 +++++++----
 drivers/input/serio/i8042-x86ia64io.h |   11 +++
 drivers/input/serio/serio.c           |    2 +
 include/linux/input.h                 |  143 +++++++++++++++++---------------
 4 files changed, 119 insertions(+), 84 deletions(-)

-- 
Dmitry
