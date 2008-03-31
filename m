Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbYCaWl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbYCaWl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYCaWlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:41:46 -0400
Received: from tim.rpsys.net ([194.106.48.114]:34492 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653AbYCaWlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:41:45 -0400
Subject: [GIT PULL] LED bugfixes
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 31 Mar 2008 23:41:30 +0100
Message-Id: <1207003290.4908.12.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for a couple of bugfixes to the led gpio driver for 2.6.25. One fixes a
potential oops, the other removes a use of preempt_count() which could
potentially deadlock.

Thanks, Richard

 drivers/leds/leds-gpio.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

David Brownell (1):
      leds: Remove incorrect use of preempt_count() from leds-gpio

Uwe Kleine-König (1):
      leds: Fix potential leds-gpio oops


