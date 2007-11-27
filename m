Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXK0GCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXK0GCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 01:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbXK0GCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 01:02:00 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:6862 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbXK0GB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 01:01:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=N6DuYCGqQFPlu+JeThtoweNtGAtQomMdRC/ZgQh31skbrtyBMVYKLsJZQbuY/ezLSPvMChHXosxAF8H3eEGasMvrCykUBjqePhAb4swZdDZ4UhNQB3g7+ffZL8IapzBq9/M5+y7LSnkoHWXJGkhANHbbbTDi3buPRMwtXGJHClg=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.24-rc3
Date: Tue, 27 Nov 2007 01:01:34 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711270101.35090.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Aristeu Rozanski (2):
      Input: add definitions for frame forward and frame back keys
      Input: adds the context menu key (HUT GenDesc 0x84)

Dmitry Torokhov (3):
      sony-laptop: fit input devices into sysfs tree
      sonypi: fit input devices into sysfs tree
      Sonypi: use synchronize_irq instead of sycnronize_sched

Herbert Valerio Riedel (1):
      Input: gpio-keys - request and configure GPIOs

Jiri Kosina (1):
      Input: i8042 - add i8042.noloop quirk for MS Virtual Machine

Mike Frysinger (1):
      Input: bf54x-keys - keypad does not exist on BF544 parts

Diffstat:
--------
 drivers/char/sonypi.c                 |    8 ++++--
 drivers/input/keyboard/Kconfig        |    2 +-
 drivers/input/keyboard/gpio_keys.c    |   38 ++++++++++++++++++++++++--------
 drivers/input/serio/i8042-x86ia64io.h |    8 +++++++
 drivers/misc/sony-laptop.c            |   10 +++++---
 include/linux/input.h                 |    5 ++++
 6 files changed, 53 insertions(+), 18 deletions(-)


-- 
Dmitry
