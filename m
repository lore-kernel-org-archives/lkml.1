Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZKPL75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZKPL75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZKPL75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:59:57 -0500
Received: from dan.rpsys.net ([93.97.175.187]:59828 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZKPL74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:59:56 -0500
Subject: [GIT PULL] LED/Backlight fixes for 2.6.32
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 16 Nov 2009 11:55:14 +0000
Message-Id: <1258372514.5799.120.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the some backlight/LED bugfixes for 2.6.32. All are simple/obvious
fixes suitable for inclusion at this point in the release cycle.

Thanks, Richard

 drivers/leds/leds-gpio.c            |    2 ++
 drivers/video/backlight/corgi_lcd.c |    5 +++--
 drivers/video/backlight/lcd.c       |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

Dmitry Eremin-Solenikov (1):
      leds-gpio: fix possible crash on OF device unbinding

Jean Delvare (1):
      backlight: lcd - Fix wrong sizeof

Pavel Machek (1):
      backlight: Fix backlight limiting on spitz/corgi devices

-- 
Richard Purdie
Intel Open Source Technology Centre

