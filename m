Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbXJVFOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbXJVFOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 01:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXJVFOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 01:14:40 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:54866 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbXJVFOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 01:14:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=MkEz+CqoII8IvxxOwmv23mUtrDVg92qoa9uej52w6I95qBre9zXN18400gQ1CH3RJ47IWo9C7d4GeYmAsXI5XhrSLrINNDP2gPMuNflkqq1aZA1CjfZIGijHIt4HwxZxOHXQOgqSu2AFCio89l3pfhuU7uxcf7kdT4OF3dFR3rk=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.24-rc0 (part 2)
Date: Mon, 22 Oct 2007 01:14:32 -0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710220114.32474.dmitry.torokhov@gmail.com>
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

Anton Ekblad (1):
      Input: appletouch - apply idle reset logic to all touchpads

Jerrold Jones (1):
      Input: usbtouchscreen - add support for GoTop tablet devices

Michael Hennerich (1):
      Input: bf54x-keys - return real error when request_irq() fails

Márton Németh (1):
      Input: i8042 - export i8042_command()

Diffstat:
--------

 drivers/input/keyboard/bf54x-keys.c        |    1 -
 drivers/input/mouse/appletouch.c           |   25 ++++++++-----------
 drivers/input/serio/i8042.c                |    4 ++-
 drivers/input/serio/i8042.h                |   22 -----------------
 drivers/input/touchscreen/Kconfig          |    6 ++++
 drivers/input/touchscreen/usbtouchscreen.c |   36 ++++++++++++++++++++++++++-
 include/linux/i8042.h                      |   35 +++++++++++++++++++++++++++
 7 files changed, 89 insertions(+), 40 deletions(-)
 create mode 100644 include/linux/i8042.h

-- 
Dmitry
