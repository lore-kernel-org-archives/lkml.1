Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbXFDFNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbXFDFNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 01:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXFDFNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 01:13:01 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:20941 "EHLO
	asav07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbXFDFNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 01:13:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvUoAPw7Y0ZKhRO4UGdsb2JhbACHM4g1AQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.22-rc3
Date: Mon, 4 Jun 2007 01:12:52 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706040112.52821.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem.

Changelog:
----------

Dmitry Torokhov (3):
      Input: db9 - do not ignore dev2 module parameter
      Input: ucb1x00 - do not access input_dev->private directly
      Input: reduce raciness when input handlers disconnect

Uwe Bugla (1):
      Input: logips2pp - fix typo in Kconfig

Diffstat:
---------

 drivers/input/evdev.c        |    2 +-
 drivers/input/joydev.c       |    2 +-
 drivers/input/joystick/db9.c |    2 +-
 drivers/input/mouse/Kconfig  |    2 +-
 drivers/input/mousedev.c     |    2 +-
 drivers/input/tsdev.c        |    2 +-
 drivers/mfd/ucb1x00-ts.c     |    7 ++++---
 7 files changed, 10 insertions(+), 9 deletions(-)

-- 
Dmitry
