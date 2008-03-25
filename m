Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYCYKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYCYKoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYCYKoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:44:06 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30904 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbYCYKoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:44:05 -0400
Date: Tue, 25 Mar 2008 11:43:39 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [GIT PULL] i2c fixes for 2.6.25
Message-ID: <20080325114339.296e9712@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem fixes for Linux 2.6.25 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

 drivers/i2c/busses/Kconfig     |    2 +-
 drivers/i2c/busses/i2c-omap.c  |   36 ++++++++++++++++++++++++++++--------
 drivers/i2c/i2c-core.c         |    4 ++--
 sound/soc/codecs/tlv320aic3x.c |    2 --
 4 files changed, 31 insertions(+), 13 deletions(-)

---------------

Bryan Wu (1):
      i2c-bfin-twi: Disable BF54x support for now

Jean Delvare (1):
      ASoC/TLV320AIC3X: Stop I2C driver ID abuse

Randy Dunlap (1):
      i2c: Fix docbook problem

Tony Lindgren (1):
      i2c-omap: Fix unhandled fault

Thanks,
-- 
Jean Delvare
