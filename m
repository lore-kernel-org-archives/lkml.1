Return-Path: <linux-kernel-owner+w=401wt.eu-S1751676AbZL0Vtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbZL0Vtb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZL0Vta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:49:30 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54080 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbZL0Vt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:49:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mt/5uthI71fdSHmDJZPasEbjlHh+wGpa3GIMy7G01ve3w2XkkZ4xgHH5MwmX/eWKtc
         4bPeByRuyt1+YpcbaRPwj95N5AWUkVRrPw/7TEihZJoTpw254Yyj6njrqjo3gIY06Ckh
         FqWVL/gr4RG4b8dDQc1k7ajr9cZDcrDTUp3PE=
Date: Sun, 27 Dec 2009 13:49:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.33-rc2
Message-ID: <20091227214924.GB16279@core.coreip.homeip.net>
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

Dmitry Torokhov (5):
      Input: speed up suspend/shutdown for PS/2 mice and keyboards
      Input: serio - do not mark kseriod freezable anymore
      Input: ff-memless - another fix for signed to unsigned overflow
      Input: iforce - fix oops on device disconnect
      Input: matrix-keypad - handle cases when GPIOs can't be wakeup sources

Jari Vanhala (2):
      Input: ff-memless - start playing FF effects immediately
      Input: ff-memless - add notion of direction to for rumble effects


Diffstat:
--------

 drivers/input/ff-memless.c                  |   48 +++++++++++++++++++++++----
 drivers/input/joystick/iforce/iforce-main.c |   26 +++------------
 drivers/input/joystick/iforce/iforce-usb.c  |   28 ++++------------
 drivers/input/joystick/iforce/iforce.h      |    2 -
 drivers/input/keyboard/atkbd.c              |    5 ++-
 drivers/input/keyboard/matrix_keypad.c      |   29 ++++++++++++----
 drivers/input/mouse/psmouse-base.c          |    5 ++-
 drivers/input/serio/serio.c                 |   11 +-----
 8 files changed, 84 insertions(+), 70 deletions(-)

-- 
Dmitry

