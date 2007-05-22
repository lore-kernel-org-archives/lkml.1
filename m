Return-Path: <linux-kernel-owner+w=401wt.eu-S934968AbXEVSBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934968AbXEVSBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760018AbXEVSBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:01:47 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:2506 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758422AbXEVSBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:01:46 -0400
Date: Tue, 22 May 2007 20:02:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.22
Message-ID: <20070522200228.4903e479@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the i2c subsystem fixes for Linux 2.6.22 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

These are 3 minor annoyances I'd like to see fixed.

 drivers/i2c/busses/i2c-s3c2410.c  |    3 ++-
 drivers/i2c/busses/i2c-tiny-usb.c |    2 +-
 drivers/i2c/i2c-core.c            |    5 +++--
 3 files changed, 6 insertions(+), 4 deletions(-)

---------------

Arnaud Patard (1):
      i2c-s3c2410: Fix build warning

David Brownell (1):
      i2c: Legacy i2c drivers shouldn't issue uevents

Jean Delvare (1):
      i2c-tiny-usb: Fix truncated adapter name

Thanks,
-- 
Jean Delvare
