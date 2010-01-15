Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0AOHzq (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 02:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832Ab0AOHzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 02:55:46 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:52239 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0AOHzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 02:55:45 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jan 2010 02:55:45 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vF8eiSW+YRJ7PPX1J55pIhFDcQN4f8C2xthONNgxiUzLN5MgrejvWwjZKSaz146vCw
         5UT/xfUxFGGMHEOPRfBCgd/xskM9hORNGFzKV+hXonJtFoHqJ7AOmouxCeln35oQ/HTd
         SZ+0zGBoh7990Zi3UKpO4aF1w6YJNbOHi9U1o=
Date: Thu, 14 Jan 2010 23:50:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.33-rc4
Message-ID: <20100115075026.GA19624@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Adam Jackson (1):
      Input: evdev - be less aggressive about sending SIGIO notifies

Daniel Drake (1):
      Input: psmouse - fix Synaptics detection when protocol is disabled

Dmitry Torokhov (3):
      Input: atkbd - fix canceling event_work in disconnect
      Input: xbox - do not use GFP_KERNEL under spinlock
      Input: add compat support for sysfs and /proc capabilities output

Elliott Sales de Andrade (1):
      Input: i8042 - add Dritek quirk for Acer Aspire 5610.

Eric W. Biederman (1):
      Input: serio - fix potential deadlock when unbinding drivers

Henrik Rydberg (1):
      Input: bcm5974 - report ABS_MT events

Miguel Aguilar (1):
      Input: davinci_keyscan - add device_enable method to platform data

Roel Kluin (1):
      Input: gf2k - fix &&/|| confusion in gf2k_connect()

Tai-hwa Liang (2):
      Input: pmouse - move Sentelic probe down the list
      Input: sentelic - fix left/right horizontal scroll mapping


Diffstat:
--------

 arch/arm/mach-davinci/include/mach/keyscan.h |    1 +
 drivers/input/evdev.c                        |    3 +-
 drivers/input/input.c                        |   86 +++++++++++++++++++++-----
 drivers/input/joystick/gf2k.c                |    2 +-
 drivers/input/joystick/xpad.c                |    4 +-
 drivers/input/keyboard/atkbd.c               |   69 ++++++++++-----------
 drivers/input/keyboard/davinci_keyscan.c     |    8 +++
 drivers/input/mouse/bcm5974.c                |   44 +++++++++++++-
 drivers/input/mouse/psmouse-base.c           |   69 ++++++++-------------
 drivers/input/mouse/sentelic.c               |    6 +-
 drivers/input/mouse/synaptics.c              |   10 +++
 drivers/input/mouse/synaptics.h              |    1 +
 drivers/input/serio/i8042-x86ia64io.h        |    7 ++
 include/linux/serio.h                        |   19 ------
 14 files changed, 208 insertions(+), 121 deletions(-)

-- 
Dmitry

