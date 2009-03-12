Return-Path: <linux-kernel-owner+w=401wt.eu-S1756491AbZCLMjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbZCLMjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZCLMjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:39:16 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:26912 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZCLMjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:39:15 -0400
Date: Thu, 12 Mar 2009 13:38:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.29
Message-ID: <20090312133858.14c1be87@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.29 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 Documentation/hwmon/lm90   |   10 ++++++++++
 drivers/hwmon/Kconfig      |    4 ++--
 drivers/hwmon/abituguru3.c |    7 +++++--
 drivers/hwmon/f75375s.c    |    2 +-
 drivers/hwmon/it87.c       |    8 ++++----
 drivers/hwmon/lm90.c       |    8 ++++----
 6 files changed, 26 insertions(+), 13 deletions(-)

---------------

Andrew Klossner (1):
      hwmon: (f75375s) Remove unnecessary and confusing initialization

Darrick J. Wong (1):
      hwmon: (lm90) Document support for the MAX6648/6692 chips

Jean Delvare (2):
      hwmon: (abituguru3) Fix I/O error handling
      hwmon: (it87) Properly decode -128 degrees C temperature

Thanks,
-- 
Jean Delvare
