Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYJINlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYJINlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbYJINkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:40:53 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6690 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759342AbYJINkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:40:52 -0400
Date: Thu, 9 Oct 2008 15:40:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.27
Message-ID: <20081009154038.64a329f2@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.27 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 Documentation/hwmon/adt7473         |   18 ++------
 Documentation/hwmon/sysfs-interface |   12 ++++++
 drivers/hwmon/abituguru3.c          |    3 +-
 drivers/hwmon/it87.c                |   70 +++++++++++++++++++++++++---------
 drivers/misc/eeepc-laptop.c         |   16 ++++++-
 5 files changed, 83 insertions(+), 36 deletions(-)

---------------

Alistair John Strachan (2):
      hwmon: (abituguru3) Enable reading from AUX3 fan on Abit AT8 32X
      hwmon: (abituguru3) Enable DMI probing feature on Abit AT8 32X

Corentin Chary (1):
      eeepc-laptop: Fix hwmon interface

Darrick J. Wong (2):
      hwmon: Define sysfs interface for energy consumption register
      hwmon: (adt7473) Fix some bogosity in documentation file

Jean Delvare (1):
      hwmon: (it87) Prevent power-off on Shuttle SN68PT

Thanks,
-- 
Jean Delvare
