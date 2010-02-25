Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab0BYMlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 07:41:44 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:59962 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab0BYMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:41:37 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
Date: Thu, 25 Feb 2010 13:41:05 +0100
Message-Id: <1267101671-23575-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: (version 3) LinuxPPS new functionalities
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds several PPS functionalities.

All patches have a specific comment but I prefer say something more:

* Patches 01-02 are just documentation about PPS support.

* Patch 03 adds PPS client support skeleton.

* Patches 04-06 add generic PPS serial support (with specific
  modifications requested by Alan Cox).

* Patches 07-08 add PPS serial support for specific hardware.

Changelog:

V3 -> V2

* On patch 01:
        - client name moved to pps-ktimer.
        - not needed continuation characters removed.
        - typos fix up.

V2 -> V1

* Old patches 01-02 removed due related to userland code and then
  managed elsewhere.

* char: n_tty.c: documentation in kerneldoc form added.

* pps: pps-ldisc: avoid using global functions over in n_tty.c

Ciao,

Rodolfo

--

 b/Documentation/serial/tty.txt     |    4 
 b/drivers/char/n_tty.c             |   17 ++++
 b/drivers/pps/Kconfig              |    2 
 b/drivers/pps/Makefile             |    1 
 b/drivers/pps/clients/Kconfig      |   18 ++++
 b/drivers/pps/clients/Makefile     |    9 ++
 b/drivers/pps/clients/pps-ktimer.c |  123 +++++++++++++++++++++++++++++
 b/drivers/pps/clients/pps-ldisc.c  |  154 +++++++++++++++++++++++++++++++++++++
 b/drivers/serial/8250.c            |   16 +++
 b/drivers/serial/amba-pl010.c      |   15 +++
 b/include/linux/serial_core.h      |   11 ++
 b/include/linux/tty.h              |    1 
 b/include/linux/tty_ldisc.h        |    8 +
 drivers/pps/clients/Kconfig        |    7 +
 drivers/pps/clients/Makefile       |    1 
 15 files changed, 386 insertions(+), 1 deletion(-)

