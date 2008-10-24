Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYJXRAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYJXRAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYJXRAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:00:25 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:56969 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbYJXRAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:00:25 -0400
Date: Fri, 24 Oct 2008 19:02:58 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Eric Miao <eric.miao@marvell.com>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [GIT] mfd pull request
Message-ID: <20081024170257.GA5528@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull a couple of mfd fixes from:
	
	git://git.o-hand.com/linux-mfd for-linus

The first one fixes a build failure when wm8400 is built in while i2c is a
module.
The second fix adds a left out Kconfig entry for da903x.

Cheers,
Samuel.

The following changes since commit e013e13bf605b9e6b702adffbe2853cfc60e7806:
  Jens Axboe (1):
        libata: fix bug with non-ncq devices

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-linus

Mark Brown (1):
      mfd: Make WM8400 depend on I2C until SPI is submitted

Samuel Ortiz (1):
      mfd: add missing Kconfig entry for da903x

 drivers/mfd/Kconfig  |   12 ++++++++++++
 drivers/mfd/Makefile |    2 ++
 2 files changed, 14 insertions(+), 0 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
