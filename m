Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXLGJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXLGJ2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 04:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbXLGJ2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 04:28:07 -0500
Received: from tim.rpsys.net ([194.106.48.114]:35793 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbXLGJ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 04:28:06 -0500
Subject: [GIT PULL] LED bugfix
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 09:27:49 +0000
Message-Id: <1197019669.4661.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

This is an LED trigger locking fix for 2.6.24. This fixes the issues
discussed in bug 9264, the change has been tested in -mm.

Thanks, Richard

 drivers/leds/led-class.c    |    6 ++---
 drivers/leds/led-triggers.c |   49 ++++++++++++++++++++++----------------------
 include/linux/leds.h        |    3 +-
 3 files changed, 30 insertions(+), 28 deletions(-)

Richard Purdie (1):
      leds: Fix led trigger locking bugs



