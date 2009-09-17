Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbZIQQNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbZIQQNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbZIQQNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:13:23 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:51761 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758204AbZIQQNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:13:22 -0400
X-Greylist: delayed 1906 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2009 12:13:22 EDT
Date: Thu, 17 Sep 2009 16:41:39 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: rt2x00dev.c:405: error: too =?utf-8?Q?few_?=
	=?utf-8?Q?arguments_to_function_=E2=80=98rt2x00crypto=5Frx=5Finsert=5Fiv?=
	=?utf-8?B?4oCZ?=
Message-ID: <20090917154138.GA31844@sucs.org>
Mail-Followup-To: Andrew Price <andy@andrewprice.me.uk>,
	Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivo,

Apologies if this has already been reported. Building today's mainline
kernel (ab86e5) I'm seeing this error:

drivers/net/wireless/rt2x00/rt2x00dev.c: In function ‘rt2x00lib_rxdone’:
drivers/net/wireless/rt2x00/rt2x00dev.c:405: warning: passing argument 3 of ‘rt2x00crypto_rx_insert_iv’ makes integer from pointer without a cast
drivers/net/wireless/rt2x00/rt2x00dev.c:405: error: too few arguments to function ‘rt2x00crypto_rx_insert_iv’

$ grep RT2 .config
CONFIG_RT2X00=y
# CONFIG_RT2400PCI is not set
CONFIG_RT2500PCI=y
# CONFIG_RT2500USB is not set
# CONFIG_RT2800USB is not set
CONFIG_RT2X00_LIB_PCI=y
CONFIG_RT2X00_LIB=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
# CONFIG_RT2860 is not set
# CONFIG_RT2870 is not set

Andrew
