Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbZJIEdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbZJIEdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 00:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZJIEdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 00:33:50 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:56607 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbZJIEdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 00:33:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=IctEeGXVuy5pxsDlkJmorGn5RHmZOgFJaomqWb4xfTR+i7bKgK4c8YJSARCg/JPJAB
         KiAS37TUlT0bEK0uk8WqUhnv3paqFCvJfKGfnVAEKe8snn7hz9Wyekqgh7fguSR9ncgR
         MX8b9uWAPMPFvf/Ldw2fZ9U18/w8p7pVrwSGA=
Date: Thu, 8 Oct 2009 21:33:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.32-rc3
Message-ID: <20091009043307.GB26462@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Amit Kucheria (1):
      Input: fix rx51 board keymap

Dmitry Torokhov (2):
      Input: libps2 - fix dependancy on i8042
      Input: i8042 - print debug data when testing AUX IRQ delivery

H Hartley Sweeten (1):
      Input: rotary_encoder - fix relative axis support

Michael Hennerich (1):
      Input: ad7879 - pass up error codes from probe functions

Sebastian Frei (1):
      Input: wistron_btns - add DMI entry for Medion WIM2030 laptop

Thomas Gruber (1):
      Input: xpad - add BigBen Interactive XBOX 360 Controller

Uwe Kleine-König (1):
      Input: sparkspkr - move remove() functions to .devexit.text


Diffstat:
--------

 arch/arm/mach-omap2/board-rx51-peripherals.c |   78 +++++++++++++-------------
 drivers/input/joystick/xpad.c                |    2 +
 drivers/input/misc/rotary_encoder.c          |    4 +-
 drivers/input/misc/sparcspkr.c               |    4 +-
 drivers/input/misc/wistron_btns.c            |    9 +++
 drivers/input/serio/Kconfig                  |   13 ++--
 drivers/input/serio/i8042.c                  |    3 +
 drivers/input/touchscreen/ad7879.c           |    4 +-
 include/linux/i2c/twl4030.h                  |    6 +-
 9 files changed, 69 insertions(+), 54 deletions(-)

-- 
Dmitry

