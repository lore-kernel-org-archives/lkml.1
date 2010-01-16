Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035Ab0APUCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0APUCY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 15:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962Ab0APUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 15:02:23 -0500
Received: from poutre.nerim.net ([62.4.16.124]:54859 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab0APUCX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 15:02:23 -0500
Date: Sat, 16 Jan 2010 21:02:18 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.33
Message-ID: <20100116210218.35c9a21d@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem fixes for Linux 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/busses/i2c-ali1563.c      |    8 ++++----
 drivers/i2c/busses/i2c-pca-isa.c      |    4 ++--
 drivers/i2c/busses/i2c-pca-platform.c |    4 ++--
 drivers/i2c/busses/i2c-piix4.c        |    4 ++--
 drivers/i2c/busses/i2c-viapro.c       |    4 ++--
 drivers/i2c/i2c-core.c                |    7 ++++---
 6 files changed, 16 insertions(+), 15 deletions(-)

---------------

Márton Németh (1):
      i2c-ali1563: Remove sparse warnings

Roel Kluin (1):
      i2c: Test off by one in {piix4,vt596}_transaction()

Thadeu Lima de Souza Cascardo (1):
      i2c: Do not use device name after device_unregister

Tobias Klauser (1):
      i2c-core: Storage class should be before const qualifier

Wolfram Sang (1):
      i2c/pca: Don't use *_interruptible

Thanks,
-- 
Jean Delvare
