Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbZLRNRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbZLRNRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 08:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZLRNRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 08:17:44 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:59574 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbZLRNRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 08:17:43 -0500
X-Greylist: delayed 1801 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2009 08:17:43 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
X-IronPort-AV: E=Sophos;i="4.47,417,1257116400";   d="scan'208";a="38435916"
Message-id: <4B2B79D3.1070706@nets.rwth-aachen.de>
Date: Fri, 18 Dec 2009 13:47:15 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-geode@lists.infradead.org
Subject: 2.6.33-rc1 compile error (geode watchdog / mfgpt related)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.33-rc1 does not compile for me:

  CC      drivers/watchdog/geodewdt.o
drivers/watchdog/geodewdt.c: In function 'geodewdt_ping':
drivers/watchdog/geodewdt.c:55: error: implicit declaration of function 'geode_mfgpt_write'
drivers/watchdog/geodewdt.c: In function 'geodewdt_probe':
drivers/watchdog/geodewdt.c:220: error: implicit declaration of function 'geode_mfgpt_alloc_timer'
drivers/watchdog/geodewdt.c:235: error: implicit declaration of function 'geode_mfgpt_toggle_event'
make[2]: *** [drivers/watchdog/geodewdt.o] Error 1
make[1]: *** [drivers/watchdog] Error 2
make: *** [drivers] Error 2

my config is available here:
http://www.umic-mesh.net/~hannemann/config-2.6.33-rc1-ah0

gcc version is:
gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu4)

Best regards,
Arnd Hannemann
