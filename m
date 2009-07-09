Return-Path: <linux-kernel-owner+w=401wt.eu-S1760131AbZGIMfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131AbZGIMfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbZGIMfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:35:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41350 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756795AbZGIMfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:35:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/3] Fix sysrq caused USB performance regressions and leak
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 13:35:17 +0100
Message-ID: <20090709123301.15654.4698.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

Alan Cox (3):
      tty: Fix the PL2303 private methods for sysrq
      tty: Fix USB kref leak
      tty: Sort out the USB sysrq changes that wrecked performance


 drivers/usb/serial/ftdi_sio.c |    2 +
 drivers/usb/serial/generic.c  |   20 ++++++++++----
 drivers/usb/serial/pl2303.c   |   58 +++++++++++++++++++++++------------------
 include/linux/usb/serial.h    |    3 +-
 4 files changed, 50 insertions(+), 33 deletions(-)

-- 
	"That was said by Eric Raymond who belongs to another movement" 
			- Richard Stallman
