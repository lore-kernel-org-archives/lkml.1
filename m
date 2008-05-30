Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYE3Ql6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYE3Ql6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 12:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYE3Qlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 12:41:51 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:30441 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbYE3Qlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 12:41:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=WcARIYqqC7f7VTVEQfFdhuyaVTh8VJlHj/2p4DWtoobfKpmcP0R5pwFs+PURE8j5vcdDPpwCkkX28cKHzytqTc9ebOigEXQ6xw/fx6BdTtbJBo91IIeNlkXqF2gExKqFJljvtlV+Re3ilK05/F0kuUP+RjJUiIH0VPBh9TLYQQY=
Date: Fri, 30 May 2008 12:41:46 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [git pull] Input updates for 2.6.26-rc4
Message-ID: <20080530164145.GA13465@anvil.corenet.prv>
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

to receive updates for the input subsystem.

Changelog:
---------

Antonio Ospite (1):
      Input: pxa27x_keypad - miscellaneous fixes

Bruno Prémont (2):
      Input: i8042 - add Dritek quirk for Acer TravelMate 660
      Input: i8042 - make sure Dritek quirk is invoked at resume

Dmitry Torokhov (2):
      Input: atkbd - mark keyboard as disabled when suspending/unloading
      Input: gtco - fix double kfree in error handling path

Henrique de Moraes Holschuh (1):
      Input: rename SW_RADIO to SW_RFKILL_ALL

Huang Weiyi (1):
      Input: apanel - remove duplicate include

Mark Brown (4):
      Input: wm97xx-core - report a phys for WM97xx touchscreens
      Input: wm97xx-core - fix driver name
      Input: wm97xx-core - fix race on PHY init
      Input: wm9713 - support five wire panels


Diffstat:
--------

 drivers/input/keyboard/atkbd.c          |    2 +
 drivers/input/keyboard/pxa27x_keypad.c  |   38 ++++++++++++++++++++----------
 drivers/input/misc/apanel.c             |    1 -
 drivers/input/serio/i8042-x86ia64io.h   |    7 +++++
 drivers/input/serio/i8042.c             |   33 ++++++++++++++++++++------
 drivers/input/tablet/gtco.c             |   17 +++++--------
 drivers/input/touchscreen/wm9713.c      |   22 ++++++++++++++++++
 drivers/input/touchscreen/wm97xx-core.c |   25 ++++++++++---------
 include/linux/input.h                   |    4 ++-
 include/linux/wm97xx.h                  |    1 +
 10 files changed, 105 insertions(+), 45 deletions(-)

-- 
Dmitry
