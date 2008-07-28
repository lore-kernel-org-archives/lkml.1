Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbYG1RAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbYG1RAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:00:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757582AbYG1Q7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:59:34 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:41475 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbYG1Q7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=tNTP0sUPG9dLLLbG/ybBhXo9znX00ZUBP8DomnLUD1JlbPtega2gq3a/SClgihLqcd
         dOmN49KQCfe3EXzMnq4Q+EwqAbg5Hlv+Ce42mQZUmfBT328cjQRHpzGmuuSsQD+sfpdq
         aB33/6+Umpt8mEudmFcWvLAWvB6ALvp1+rZ0U=
Date: Mon, 28 Jul 2008 12:59:26 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.27-rc0 (round 2)
Message-ID: <20080728165926.GA21561@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
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

Dan Liang (1):
      Input: add driver for Atmel integrated touchscreen controller

Dmitry Torokhov (1):
      Input: serio - mark serio_register_driver() __must_check

Hans-Christian Egtvedt (1):
      Input: ads7846 - optimize order of calculating Rt in ads7846_rx()

Harvey Harrison (1):
      Input: ads7846 - fix sparse endian warnings

Huang Weiyi (1):
      Input: uinput - remove duplicate include

Shaohua Li (1):
      Input: serio - offload resume to kseriod


Diffstat:
--------

 drivers/input/misc/uinput.c              |    1 -
 drivers/input/serio/serio.c              |   55 ++++--
 drivers/input/touchscreen/Kconfig        |   12 +
 drivers/input/touchscreen/Makefile       |    1 +
 drivers/input/touchscreen/ads7846.c      |   16 +-
 drivers/input/touchscreen/atmel_tsadcc.c |  332 ++++++++++++++++++++++++++++++
 include/linux/serio.h                    |    3 +-
 7 files changed, 390 insertions(+), 30 deletions(-)
 create mode 100644 drivers/input/touchscreen/atmel_tsadcc.c

-- 
Dmitry
