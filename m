Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZEANfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZEANfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZEANfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:35:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:8172 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZEANfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:35:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xKoHzn6iL2C7OltQZn/dUmDu4cJXwUDxsHAWVPw+c/wjiZBoMYyYNIMJE+SFIAaGHN
         RiU891Al4BgesJRcevkQIvpGdJOarqL7Aa+KcATp0BCCkJA5Yl5OpJimZNEpg4BSKyzl
         CijHMoa5y8gHhzFXRYeL+YMOgElZiPa06e+d4=
Date: Fri, 1 May 2009 06:35:16 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.30-rc2
Message-ID: <20090501133516.GB20000@dtor-d630.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Mostly small fixes to the
drivers, new documentation, update for bcm5974 to support touchpads on
unibody Macbooks, and new multitouch protocol definitions so userspace
can proceed with writing their pieces.

Changelog:
---------

Arjan Opmeer (2):
      Input: elantech - provide a workaround for jumpy cursor on firmware 2.34
      Input: elantech - make sure touchpad is really in absolute mode

Ben Nizette (4):
      Input: omap-keypad - use disable_irq_nosync() in irq handler
      Input: sa1111ps2 - use disable_irq_nosync() in irq handlers
      Input: tsc2007 - use disable_irq_nosync() in irq handler
      Input: ucb1400 - use disable_irq_nosync() in irq handler

Bob Copeland (1):
      Input: appletouch - fix DMA to/from stack buffer

Dmitry Torokhov (2):
      Input: ALPS - add signature for Toshiba Satellite Pro M10
      Input: lifebook - add DMI entry for Fujitsu B-2130

Henrik Rydberg (8):
      Input: bcm5974 - prepare for a new trackpad header type
      Input: bcm5974 - add quad-finger tapping
      Input: bcm5974 - Add support for the Macbook 5 (Unibody)
      Input: bcm5974 - augment debug information
      Input: bcm5974 - add documentation for the driver
      Input: allow certain EV_ABS events to bypass all filtering
      Input: add detailed multi-touch finger data report protocol
      Input: document the multi-touch (MT) protocol

Ping Cheng (1):
      Input: wacom - fix TabletPC touch bug


Diffstat:
--------

 Documentation/input/bcm5974.txt              |   65 ++++++++++++
 Documentation/input/multi-touch-protocol.txt |  140 ++++++++++++++++++++++++++
 drivers/input/input.c                        |   36 +++++++
 drivers/input/keyboard/omap-keypad.c         |   16 +++-
 drivers/input/mouse/alps.c                   |    1 +
 drivers/input/mouse/appletouch.c             |   24 ++++-
 drivers/input/mouse/bcm5974.c                |  108 +++++++++++++++-----
 drivers/input/mouse/elantech.c               |   48 ++++++++--
 drivers/input/mouse/elantech.h               |    5 +-
 drivers/input/mouse/lifebook.c               |    6 +
 drivers/input/serio/sa1111ps2.c              |    2 +-
 drivers/input/tablet/wacom.h                 |    5 +-
 drivers/input/tablet/wacom_sys.c             |   13 ++-
 drivers/input/touchscreen/tsc2007.c          |    2 +-
 drivers/input/touchscreen/ucb1400_ts.c       |    2 +-
 include/linux/input.h                        |   24 +++++
 16 files changed, 446 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/input/bcm5974.txt
 create mode 100644 Documentation/input/multi-touch-protocol.txt

-- 
Dmitry

