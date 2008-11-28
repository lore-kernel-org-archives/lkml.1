Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYK1Odg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYK1Odg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 09:33:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYK1Od0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 09:33:26 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:30688 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYK1OdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 09:33:25 -0500
Date: Fri, 28 Nov 2008 15:33:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.28
Message-ID: <20081128153313.1341113f@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the i2c subsystem fixes for Linux 2.6.28 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

 drivers/i2c/busses/i2c-parport.c |    4 +-
 drivers/i2c/chips/isp1301_omap.c |   65 +++++++++++++++++++++++++++----------
 drivers/i2c/i2c-core.c           |    2 +-
 3 files changed, 50 insertions(+), 21 deletions(-)

---------------

David Brownell (1):
      i2c/isp1301_omap: Build fixes

Jean Delvare (2):
      i2c: Remove i2c clients in reverse order
      i2c-parport: Fix misplaced parport_release call

Thanks,
-- 
Jean Delvare
