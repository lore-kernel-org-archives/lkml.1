Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbXFMGLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbXFMGLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbXFMGK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:10:58 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:19313 "EHLO
	asav09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbXFMGK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:10:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgeAI0nb0ZKhRO4UGdsb2JhbACBTY1tAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.22-rc4
Date: Wed, 13 Jun 2007 02:10:55 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706130210.56559.dtor@insightbb.com>
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
      Input: i8042 - add ASUS P65UP5 to the noloop list
      Input: i8042 - add ULI EV4873 to noloop list
      Input: move input-polldev to drivers/input

Ondrej Zary (1):
      Input: usbtouchscreen - fix fallout caused by move from drivers/usb

Diffstat:
---------

 drivers/input/Kconfig                      |   13 ++++++++
 drivers/input/Makefile                     |    1 +
 drivers/input/{misc => }/input-polldev.c   |    0 
 drivers/input/misc/Kconfig                 |   11 -------
 drivers/input/misc/Makefile                |    1 -
 drivers/input/serio/i8042-x86ia64io.h      |   18 +++++++++++
 drivers/input/touchscreen/usbtouchscreen.c |   44 ++++++++++++++--------------
 7 files changed, 54 insertions(+), 34 deletions(-)
 rename drivers/input/{misc => }/input-polldev.c (100%)


-- 
Dmitry
