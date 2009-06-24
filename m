Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbZFXLhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbZFXLhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbZFXLgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:18 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25441 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbZFXLgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:17 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 00/20] omapfb: Add support for new LCDs / misc fixes
Date: Wed, 24 Jun 2009 14:33:25 +0300
Message-Id: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
X-OriginalArrivalTime: 24 Jun 2009 11:35:50.0651 (UTC) FILETIME=[ECDB84B0:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I'd like to ask for the merging of this patchset into Linus' tree.
It adds support for new LCDs on OMAP based boards (01-12) and fixes
generic parts of the omapfb driver (13-20). The changes have been
staged in the Linux OMAP tree for quite a long time, and got reviewed
on the linux-fbdev-devel list.

Note that this is about the existing "DSS1" FB driver which will
eventually be replaced by Tomi Valkeinen's DSS2 FB driver.

Thanks,
Imre

[PATCH 01/20] omapfb: Add support for the Apollon LCD
[PATCH 02/20] omapfb: Add support for MIPI-DCS compatible LCDs
[PATCH 03/20] omapfb: Add support for the Amstrad Delta LCD
[PATCH 04/20] omapfb: Add support for the 2430SDP LCD
[PATCH 05/20] omapfb: Add support for the OMAP2EVM LCD
[PATCH 06/20] omapfb: Add support for the 3430SDP LCD
[PATCH 07/20] omapfb: Add support for the OMAP3 EVM LCD
[PATCH 08/20] omapfb: Add support for the OMAP3 Beagle DVI output
[PATCH 09/20] omapfb: Add support for the Gumstix Overo LCD
[PATCH 10/20] omapfb: Add support for the ZOOM MDK LCD
[PATCH 11/20] omapfb: Add support for rotation on the Blizzard LCD ctrl
[PATCH 12/20] N770: Enable LCD MIPI-DCS in Kconfig
[PATCH 13/20] omapfb: dispc: Various typo fixes
[PATCH 14/20] omapfb: dispc: Disable iface clocks along with func clocks
[PATCH 15/20] omapfb: dispc: Enable wake up capability
[PATCH 16/20] omapfb: dispc: Allow multiple external IRQ handlers
[PATCH 17/20] omapfb: suspend/resume only if FB device is already initialized
[PATCH 18/20] omapfb: Fix coding style / remove dead line
[PATCH 19/20] omapfb: Add FB manual update option to Kconfig
[PATCH 20/20] omapfb: HWA742: fix pointer to be const

