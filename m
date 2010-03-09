Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab0CIRW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:22:26 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54649 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0CIRWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:22:24 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 00/13] Blackfin SPORT UART updates
Date: Tue,  9 Mar 2010 12:25:27 -0500
Message-Id: <1268155540-8241-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was waiting for the mondo SPORT UART patch to be merged, so now that
that's done, we can push up the rest.

All of this stuff is fine for 2.6.34 or 2.6.35.  I don't believe any of
these are "really important" bugfixes.

Mike Frysinger (4):
  serial: bfin_sport_uart: drop useless status masks
  serial: bfin_sport_uart: pull in bfin_sport.h for SPORT defines
  serial: bfin_sport_uart: drop the experimental markings
  serial: bfin_sport_uart: drop redundant cpu depends

Sonic Zhang (9):
  serial: bfin_sport_uart: work around anomaly 05000473 (make 32bit
    fifo read atomic)
  serial: bfin_sport_uart: shorten the SPORT TX waiting loop
  serial: bfin_sport_uart: remove unused peripheral pin lists
  serial: bfin_sport_uart: add missing mapbase initialization
  serial: bfin_sport_uart: rename early platform driver class string
  serial: bfin_sport_uart: add support for CTS/RTS via GPIOs
  serial: bfin_sport_uart: protect changes to uart_port
  serial: bfin_sport_uart: zero sport_uart_port if allocated
    dynamically
  serial: bfin_sport_uart: only enable SPORT TX if data is to be sent

 drivers/serial/Kconfig           |   30 +++++-
 drivers/serial/bfin_sport_uart.c |  206 ++++++++++++++++++++++++++------------
 drivers/serial/bfin_sport_uart.h |   27 +++++-
 3 files changed, 194 insertions(+), 69 deletions(-)

