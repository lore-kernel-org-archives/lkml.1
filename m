Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZBKHH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZBKHH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZBKHHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:07:18 -0500
Received: from harmaja.edelkey.net ([213.138.147.141]:51304 "EHLO
	harmaja.edelkey.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbZBKHHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:07:14 -0500
From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
To: david-b@pacbell.net
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
       jouni.hogander@nokia.com, broonie@sirena.org.uk
Subject: [PATCH 0/2] TWL: USB: Start using twl4030/5030 regulator driver
Date: Wed, 11 Feb 2009 09:06:40 +0200
Message-Id: <1234336002-26372-1-git-send-email-kalle.jokiniemi@digia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-OriginalArrivalTime: 11 Feb 2009 07:06:44.0644 (UTC) FILETIME=[4C259E40:01C98C17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These couple of patches enable dynamic swithcing of the
regulators used by twl4030 usb tranceiver.

This set replaces the single patch "USB: disable twl4030
USB regulators when cable unplugged" sent previously.
The change to previous version is that possible errors
in regulator_get are now handled and the twl4030 usb
driver requires TWL_REGULATOR support to be compiled.

Thanks to Aaro Koskinen for reporing these problems. 
Original patch by Kalle Jokiniemi, fixes by Jouni
Hogander.

Jouni Hogander (2):
      TWL: USB: disable VUSB regulators when cable unplugged
      USB: OTG: Twl4030 depends on REGULATOR_TWL4030

 drivers/usb/otg/Kconfig       |    2 +-
 drivers/usb/otg/twl4030-usb.c |   45 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 7 deletions(-)



