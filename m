Return-Path: <linux-kernel-owner+w=401wt.eu-S1751719Ab0AGK0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab0AGK0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 05:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475Ab0AGK0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 05:26:41 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:34071 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870Ab0AGK0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 05:26:40 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
X-IronPort-AV: E=Sophos;i="4.49,234,1262559600";   d="scan'208";a="40009753"
Message-id: <4B45B6DD.4060903@nets.rwth-aachen.de>
Date: Thu, 07 Jan 2010 11:26:37 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-geode@lists.infradead.org, rpurdie@rpsys.net
Subject: 2.6.33-rc3 regression: leds_alix2: can't allocate I/O for GPIO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 2.6.33-rc3 the LEDs are not working anymore on my Geode embedded board:
If I remember correctly this was working fine with 2.6.32, but certainly with 2.6.31

relevant dmesg output of 2.6.33-rc3:

[    0.709643] cs5535_gpio: base=0x6100 mask=0xb003c66 major=253

[    2.207947] leds_alix2: system is recognized as "PC Engines ALIX.2 v0.99h"
[    2.228678] leds_alix2: can't allocate I/O for GPIO


For reference dmesg of 2.6.31.3:

[    0.611953] cs5535_gpio: base=0x6100 mask=0xb003c66 major=253

[    2.379114] leds_alix2: system is recognized as "PC Engines ALIX.2"
[    2.399097] Registered led device: alix:1
[    2.411404] Registered led device: alix:2
[    2.423720] Registered led device: alix:3

Best regards,
Arnd
