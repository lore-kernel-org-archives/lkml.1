Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZB1WI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZB1WI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbZB1WIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:08:50 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:36100 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934AbZB1WIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:08:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=LVWu21yLglmP8Pl4OW1y6ICOCBhqjI+ve3CelifK0GAc4u7zDMbQTC91HyUhXqTDNU
         NJWCJssY7UT543BRn02yEQkmU57Q3cJoix99eNH8FOFNB2EP/OpIM3ZuHdDvIM4nOkoI
         9Gsmvi54ZFGWlOEIj4VJKqHOMP5L5kjqBcOhE=
Date: Sat, 28 Feb 2009 14:08:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.29-rc6
Message-ID: <20090228220835.GA16208@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Nothing exciting, just a few
small fixups.

Changelog:
---------

Andy Whitcroft (1):
      Input: synaptics - ensure we reset the device on resume

Arjan Opmeer (1):
      Input: elantech - touchpad driver miss-recognising logitech mice

Bastien Nocera (1):
      Input: uvc - the button on the camera is KEY_CAMERA

Dan Streetman (1):
      Input: usbtouchscreen - allow reporting calibrated data

Daniel Mierswa (1):
      Input: atkbd - make forced_release_keys[] static

Daniel Ritz (1):
      Input: usbtouchscreen - fix eGalax HID ignoring

Jean Delvare (1):
      Input: psmouse - make MOUSE_PS2_LIFEBOOK depend on X86

Kay Sievers (1):
      Input: struct device - replace bus_id with dev_name(), dev_set_name()

Roel Kluin (3):
      Input: bf54x-keys - fix debounce time validation
      Input: pxa930_trkball - fix write timeout handling
      Input: ambakmi - fix timeout handling in amba_kmi_write()

Uwe Kleine-König (4):
      Input: corgikbd - mark probe function as __devinit
      Input: corgi_ts - mark probe function as __devinit
      Input: omap-keypad - mark probe function as __devinit
      Input: spitzkbd - mark probe function as __devinit


Diffstat:
--------

 drivers/input/keyboard/atkbd.c             |    4 +-
 drivers/input/keyboard/bf54x-keys.c        |    4 +-
 drivers/input/keyboard/corgikbd.c          |    8 +++---
 drivers/input/keyboard/omap-keypad.c       |    8 +++---
 drivers/input/keyboard/spitzkbd.c          |    8 +++---
 drivers/input/mouse/Kconfig                |    2 +-
 drivers/input/mouse/elantech.c             |   32 +++++++++++++++++++++-------
 drivers/input/mouse/pxa930_trkball.c       |    2 +-
 drivers/input/mouse/synaptics.c            |    9 +++----
 drivers/input/serio/ambakmi.c              |    6 ++--
 drivers/input/serio/gscps2.c               |    2 +-
 drivers/input/serio/sa1111ps2.c            |    4 +-
 drivers/input/touchscreen/atmel_tsadcc.c   |    2 +-
 drivers/input/touchscreen/corgi_ts.c       |    9 ++++---
 drivers/input/touchscreen/tsc2007.c        |    3 +-
 drivers/input/touchscreen/usbtouchscreen.c |   20 +++++++++++++++-
 drivers/media/video/uvc/uvc_status.c       |   10 +++++---
 17 files changed, 84 insertions(+), 49 deletions(-)

-- 
Dmitry

