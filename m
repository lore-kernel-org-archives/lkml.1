Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbXHaCF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbXHaCF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 22:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763907AbXHaCFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 22:05:05 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:58007 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418AbXHaCFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 22:05:01 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALMT10ZKhRO4/2dsb2JhbACBVg
X-IronPort-AV: E=Sophos;i="4.19,328,1183348800"; 
   d="scan'208";a="120121110"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.23-rc4
Date: Thu, 30 Aug 2007 01:06:50 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708300106.51111.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates to the input subsystem.

Changelog:
---------

Adrian Bunk (1):
      Input: psmouse - make dummy touchkit_ps2_detect() static

Andrew Morton (1):
      Input: iforce - fix 'unused variable' warning

Fernando Luis Vázquez Cao (1):
      Input: i8042 - fix retrun value of i8042_aux_test_irq

Jesper Juhl (1):
      Input: gpio_keys - remove duplicate includes

Mariusz Kozlowski (1):
      Input: gscps2 - convert to use kzalloc

Diffstat:
--------

 drivers/input/joystick/iforce/iforce-packets.c |    8 ++++----
 drivers/input/keyboard/gpio_keys.c             |    1 -
 drivers/input/mouse/touchkit_ps2.h             |    3 ++-
 drivers/input/serio/gscps2.c                   |    6 ++----
 drivers/input/serio/i8042.c                    |    4 +++-
 5 files changed, 11 insertions(+), 11 deletions(-)

-- 
Dmitry
