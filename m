Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYHOC2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYHOC2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 22:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYHOC2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 22:28:31 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:17607 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYHOC2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 22:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=L6wc0per9g3TxzAiyeRj+t6GgsJTVVAC1B98lbrq2X7+E30ihPWAp6pNOtNveCp79i
         /wxfEPKx0OyeVhlFrtUzjUM77JOZz9RcSipaJ8aPdkz3ATc8uVb+2f7gAAGJDK+1MRys
         0+VxZmiRp4lWnyKUs8fDDqtH292T++bVoc2tg=
Date: Thu, 14 Aug 2008 22:28:26 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.27-rc0 (round 2)
Message-ID: <20080815022826.GB9438@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a bunch of
small fixes, the change to evdev to print an warning abount invalid
parameters to EVIOCGBIT ioctl and a new driver for Macbook Air
touchpads.

Changelog:
---------

Andrew Morton (1):
      Input: xilinx_ps2 - fix warning

Carlos Corbacho (1):
      Input: i8042 - Add Dritek quirk for Acer TravelMate 4280

Dmitry Torokhov (2):
      Input: paper over a bug in Synaptics X driver
      Input: bcm5974 - implement autosuspend support

Harley Laue (1):
      Input: xpad - add Pelican Eclipse D-Pad to the list of devices

Henrik Rydberg (1):
      Input: bcm5974 - add driver for Macbook Air and Pro Penryn touchpads

Linus Torvalds (1):
      Input: evdev - split EVIOCGBIT handlig into a separate function

Mark Brown (1):
      Input: wm97xx - enable sub-drivers by default

Uwe Kleine-König (2):
      Input: gpio-keys - fix possible NULL pointer dereference
      Input: gpio-keys - make gpio_keys_device_driver static


Diffstat:
--------

 drivers/hid/usbhid/hid-quirks.c       |   12 +-
 drivers/input/evdev.c                 |   63 ++-
 drivers/input/joystick/xpad.c         |    1 +
 drivers/input/keyboard/gpio_keys.c    |    3 +-
 drivers/input/mouse/Kconfig           |   23 ++
 drivers/input/mouse/Makefile          |    1 +
 drivers/input/mouse/bcm5974.c         |  681 +++++++++++++++++++++++++++++++++
 drivers/input/serio/i8042-x86ia64io.h |    7 +
 drivers/input/serio/xilinx_ps2.c      |    4 +-
 drivers/input/touchscreen/Kconfig     |   21 +-
 10 files changed, 775 insertions(+), 41 deletions(-)
 create mode 100644 drivers/input/mouse/bcm5974.c

-- 
Dmitry
