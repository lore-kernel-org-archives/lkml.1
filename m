Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZKROa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZKROa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbZKROa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:30:57 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40579 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757167AbZKROa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:30:57 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 00/12] Series short description
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:14:32 +0000
Message-ID: <20091118141354.3346.16910.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Further serial whacking (Resend). Mostly attack the moxa/mxser/isicom drivers
and try to beat them into shape.

---

Alan Cox (12):
      moxa: split open lock
      moxa: Kill the use of lock_kernel
      moxa: Fix modem op locking
      moxa: Kill off the throttle method
      Locking clean up
      moxa: rework the locking a bit
      moxa: Use more tty_port ops
      isicom: fix deadlock on shutdown
      mxser: Use the new locking rules to fix setserial properly
      mxser: use the tty_port_open method
      isicom: sort out the board init logic
      isicom: switch to the new tty_port_open helper


 drivers/char/isicom.c  |  115 ++++---------------
 drivers/char/moxa.c    |  291 ++++++++++++++----------------------------------
 drivers/char/mxser.c   |  248 ++++++++++++++++++-----------------------
 include/linux/isicom.h |    1 
 4 files changed, 219 insertions(+), 436 deletions(-)

