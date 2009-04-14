Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZDNM6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZDNM6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZDNM6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:58:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32930 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835AbZDNM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:58:13 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/4] Small fixes for rc2
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2009 14:57:21 +0100
Message-ID: <20090414135501.13935.13500.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---

Alan Cox (3):
      parport: Fix various uses of parport_pc
      tty: Fix leak in ti-usb
      cdc-acm: Fix long standing abuse of tty->low_latency

Tony Breeds (1):
      parport_pc: Fix build failure drivers/parport/parport_pc.c for powerpc


 arch/powerpc/include/asm/parport.h    |    2 +-
 arch/sparc/include/asm/parport.h      |    5 +++--
 drivers/parisc/superio.c              |    3 ++-
 drivers/usb/class/cdc-acm.c           |    4 ----
 drivers/usb/serial/ti_usb_3410_5052.c |   26 ++++++++++++++------------
 5 files changed, 20 insertions(+), 20 deletions(-)

--
 "And the nice thing is you don't need to be able to type, because every
  possible keystroke does {something} for/to you. Anything from point out
  off-by-one errors to perform a sex change on your gerbil."
			-- Bill Davidsen describing emacs

