Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0BXHho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:37:44 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:39422 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0BXHhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:37:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=qq4HHyWGV8Qp3OU8RaKTWkZNVlVGkwg18aEsylPoJ1+BGOMPEWQbKfeLeIey83/7hS
         f0y13oA04AblxS00E+oU0/uF/HCh5BaUtADGyGxDbUPZ7k72UWfwXewk5kPtOcAL8Ees
         beKT+hjQH+dy9XmMQwVFZxkWemMEzPO/Hhj70=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 00/14] Assorted small patches for regulators
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 23 Feb 2010 23:37:39 -0800
Message-ID: <20100224073342.15964.8863.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

I happend to peek into drivers/regulator and saw a bunch of small issues, so
here goes. The patches are against linux-next, compile-tested only since I
don't have the hardware,

Please consider applying.

Thanks,

Dmitry

---

Dmitry Torokhov (14):
      Regulators: max8925-regulator - clean up driver data after removal
      Regulators: wm8400 - cleanup platform driver data handling
      Regulators: wm8994 - clean up driver data after removal
      Regulators: wm831x-xxx - clean up driver data after removal
      Regulators: pcap-regulator - clean up driver data after removal
      Regulators: max8660 - annotate probe and remove methods
      Regulators: max1586 - annotate probe and remove methods
      Regulators: lp3971 - fail if platform data was not supplied
      Regulators: tps6507x-regulator - mark probe method as __devinit
      Regulators: tps65023-regulator - mark probe method as __devinit
      Regulators: twl-regulator - mark probe function as __devinit
      Regulators: fixed - annotate probe and remove methods
      Regulators: ab3100 - fix probe and remove annotations
      Regulators: virtual - use sysfs attribute groups


 drivers/regulator/ab3100.c             |    6 ++-
 drivers/regulator/fixed.c              |   19 +++++-----
 drivers/regulator/lp3971.c             |   58 +++++++++++++++--------------
 drivers/regulator/max1586.c            |    9 +++--
 drivers/regulator/max8660.c            |   11 +++---
 drivers/regulator/max8925-regulator.c  |    6 ++-
 drivers/regulator/pcap-regulator.c     |    8 +++-
 drivers/regulator/tps65023-regulator.c |   35 ++++++++----------
 drivers/regulator/tps6507x-regulator.c |   34 ++++++++---------
 drivers/regulator/twl-regulator.c      |    2 +
 drivers/regulator/virtual.c            |   64 +++++++++++++++++---------------
 drivers/regulator/wm831x-dcdc.c        |   12 ++++++
 drivers/regulator/wm831x-isink.c       |    3 ++
 drivers/regulator/wm831x-ldo.c         |    5 +++
 drivers/regulator/wm8400-regulator.c   |   13 ++++---
 drivers/regulator/wm8994-regulator.c   |   11 ++++--
 include/linux/mfd/wm8400.h             |    4 ++
 17 files changed, 164 insertions(+), 136 deletions(-)
