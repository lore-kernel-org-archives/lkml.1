Return-Path: <linux-kernel-owner+w=401wt.eu-S1753200AbYCREuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbYCREuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 00:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYCREtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 00:49:51 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:45073 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYCREtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 00:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=fjJ+vM45Xqa5Pun54EFwjguNPJOB4nvtZGywZwT0woc2rAe/hniia24Y1qz1yb+G1B49PBl4nDAQddg9/P/C/ipFMyunb4krZWG5y8/Zt7hFGKGsiPTATCRNwsVYHsZbAG4NmTOADnpJS0MyXHXVZdPyTDgR39XF1hDefhb+8kU=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for 2.6.25-rc6
Date: Tue, 18 Mar 2008 00:42:36 -0400
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jikos@jikos.cz>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803180042.36695.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Andrew Morton (1):
      Input: ads7846 - fix uninitialized var warning

Dmitry Torokhov (1):
      Input: ALPS - put secondary device in proper place in sysfs

Jiri Kosina (2):
      Input: i8042 - add Lenovo 3000 N100 to nomux blacklist
      Input: document i8042.noloop

Laszlo Kajan (1):
      Input: ALPS - fix forward/back buttons reversed on Acer 5520-5290

Ping Cheng (1):
      Input: wacom - add support for Bamboo1, BambooFun, and Cintiq 12WX

Roland Dreier (1):
      Input: i8042 - fix warning on non-x86 builds

Samuel Thibault (1):
      Input: add keyboard notifier documentation

Thomas Bogendoerfer (1):
      Input: i8042 - add SNI RM support

Yoichi Yuasa (1):
      Input: cobalt_btns - assorted fixes

Diffstat:
--------

 Documentation/input/notifier.txt      |   52 +++++++++++++++++++++++
 Documentation/kernel-parameters.txt   |    2 +
 drivers/input/misc/cobalt_btns.c      |   16 ++++----
 drivers/input/mouse/alps.c            |    5 +-
 drivers/input/serio/i8042-snirm.h     |   75 +++++++++++++++++++++++++++++++++
 drivers/input/serio/i8042-x86ia64io.h |    7 +++
 drivers/input/serio/i8042.c           |    3 +-
 drivers/input/serio/i8042.h           |    2 +
 drivers/input/tablet/wacom.h          |    6 ++-
 drivers/input/tablet/wacom_sys.c      |    6 +++
 drivers/input/tablet/wacom_wac.c      |   31 +++++++++----
 drivers/input/tablet/wacom_wac.h      |    1 +
 drivers/input/touchscreen/ads7846.c   |    2 +-
 13 files changed, 183 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/input/notifier.txt
 create mode 100644 drivers/input/serio/i8042-snirm.h

-- 
Dmitry
