Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470Ab0ALIju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab0ALIju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200Ab0ALIjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:39:49 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:64626 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0ALIjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:39:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Lglv8iSqxl1oK6lQqYRfmdZBPu1MZFla37jJJR/luE7lC9hy92w5VTM+TUSU+qhhA/
         OxAwoku4NFZxDb/ciF+tiPRZT3/XQzZ2eGN2KNDO38bGK9GfmnDlh5F4LPwRXTyT+UL6
         1DcWD0au0lF6RLjqG+QBs2sZackmoPVSIyCLg=
Date: Tue, 12 Jan 2010 00:39:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.33-rc3
Message-ID: <20100112083943.GA13714@core.coreip.homeip.net>
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


Diffstat:
--------

 arch/arm/mach-davinci/include/mach/keyscan.h |    1 +
 drivers/input/evdev.c                        |    3 +-
 drivers/input/input-compat.h                 |    2 +
 drivers/input/input.c                        |   74 ++++++++++++++++++++-----
 drivers/input/joystick/gf2k.c                |    2 +-
 drivers/input/joystick/xpad.c                |    4 +-
 drivers/input/keyboard/atkbd.c               |   69 +++++++++++------------
 drivers/input/keyboard/davinci_keyscan.c     |    8 +++
 drivers/input/mouse/bcm5974.c                |   44 +++++++++++++++-
 drivers/input/mouse/psmouse-base.c           |   41 ++++----------
 drivers/input/mouse/synaptics.c              |   10 ++++
 drivers/input/mouse/synaptics.h              |    1 +
 drivers/input/serio/i8042-x86ia64io.h        |    7 +++
 include/linux/serio.h                        |   19 -------
 14 files changed, 180 insertions(+), 105 deletions(-)

-- 
Dmitry

