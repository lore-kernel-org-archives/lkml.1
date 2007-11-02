Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbXKBRH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbXKBRH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbXKBRHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:07:25 -0400
Received: from mxsf05.insightbb.com ([74.128.0.75]:19427 "EHLO
	mxsf05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbXKBRHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:07:22 -0400
X-IronPort-AV: E=Sophos;i="4.21,363,1188792000"; 
   d="scan'208";a="100094298"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HANf1KkdKjlCP/2dsb2JhbACBWw
X-IronPort-AV: E=Sophos;i="4.21,363,1188792000"; 
   d="scan'208";a="153648353"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.24-rc1
Date: Fri, 2 Nov 2007 13:07:19 -0400
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711021307.19621.dtor@insightbb.com>
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

Adrian Bunk (1):
      Input: hp_sdc.c - fix section mismatch

Carlos Corbacho (1):
      Input: Add Euro and Dollar key codes

Dmitry Torokhov (2):
      Input: appletouch - idle reset logic broke older Fountains
      Input: linux-input mailing list moved to vger.kernel.org

Helge Deller (1):
      Input: inport, logibm - use KERN_INFO when reporting missing mouse

Johannes Berg (1):
      Input: appletouch - add Johannes Berg as maintainer

Joshua J Bowman (1):
      Input: xpad - add more USB IDs

Diffstat:
--------

 MAINTAINERS                      |   11 +++-
 drivers/input/joystick/xpad.c    |    2 +
 drivers/input/mouse/appletouch.c |  125 +++++++++++++++++++++++---------------
 drivers/input/mouse/inport.c     |    2 +-
 drivers/input/mouse/logibm.c     |    2 +-
 drivers/input/serio/hp_sdc.c     |    4 -
 include/linux/input.h            |    3 +
 7 files changed, 92 insertions(+), 57 deletions(-)

-- 
Dmitry
