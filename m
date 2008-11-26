Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbYKZQ0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbYKZQ0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 11:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYKZQ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 11:26:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:31347 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbYKZQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:26:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=M96po3k40KtjLOOJ1iwp3AEVpm3XuCsfikAVX2Ufe+dykhpXC7FIcttne4UsB62E7N
         F703Kr7s25vrZiQ8uU5kM3nffjZniM5vitE32DJGk5jHsj3YxrozaZwnVNbyl9vGwNp6
         HX2lEMWK9g18sYtb82XauE25wV6Xs6zJO4MP0=
Date: Wed, 26 Nov 2008 11:26:20 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.28-rc6
Message-ID: <20081126162620.GA27380@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Mostly small fixups with the
exception of Wacom driver, but the change only adds support for the new
tablet PCs and should not affect devices that were already supported by
earlier versions of the driver.

Changelog:
---------

Andres Salomon (1):
      Input: psmouse - fix incorrect validate_byte check in OLPC protocol

Arjan van de Ven (1):
      Input: replace spin_lock_bh with spin_lock_irqsave in ml_ff_playback

Daniel Gimpelevich (1):
      Input: cm109 - add keymap for ATCom AU-100 phone

Dmitri Vorobiev (1):
      Input: fix the example of an input device driver

Dmitry Torokhov (1):
      Input: i8042 - add Compal Hel80 laptop to nomux blacklist

Herton Ronaldo Krzesinski (1):
      Input: i8042 - add Dell XPS M1530 to nomux list

Jiri Pirko (1):
      Input: atkbd - cancel delayed work before freeing its structure

Matthew Garrett (1):
      Input: atkbd - add keymap quirk for Inventec Symphony systems

Ping Cheng (1):
      Input: wacom - add support for new USB Tablet PCs

Vojtech Pavlik (1):
      Input: elo - fix format string in elo driver


Diffstat:
--------

 Documentation/input/input-programming.txt |    3 +-
 drivers/input/ff-memless.c                |    5 +-
 drivers/input/keyboard/atkbd.c            |   27 ++++-
 drivers/input/misc/cm109.c                |   37 +++++-
 drivers/input/mouse/hgpk.c                |    2 +-
 drivers/input/serio/i8042-x86ia64io.h     |   14 ++
 drivers/input/tablet/wacom.h              |   13 +-
 drivers/input/tablet/wacom_sys.c          |  228 +++++++++++++++++++++++++----
 drivers/input/tablet/wacom_wac.c          |  160 ++++++++++++++++++--
 drivers/input/tablet/wacom_wac.h          |    4 +
 drivers/input/touchscreen/elo.c           |    2 +-
 11 files changed, 439 insertions(+), 56 deletions(-)

-- 
Dmitry
