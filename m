Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZDFPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZDFPdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZDFPdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:33:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56949 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752836AbZDFPdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:33:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [RESEND PATCH 00/27] Serial updates for 2.6.30
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:31:33 +0100
Message-ID: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As the previous set but the queue has grown a bit in the meantime. Although
these are all fixes and minor things it would be good to actually get them in
so some of the annoying bug cures can get pushed on into stable.

Alan

---

Alan Cox (6):
      8250: Fix warning
      symbol: Remove various bits of left over junk
      tty: pl2303 needs identifiers for Siemens S81 as well as EF81
      cdc-acm: zydas 1602 identifier needed
      isicom: isicom kref leak fix
      ucc: Fix leaky error path

Alexander Beregalov (1):
      mux: fix build problem

Breno Leitao (3):
      icom: remove unused variables
      jsm: Fix the return variable and removing the unused retval.
      jsm: define init function as __devinit

Danny Kukawka (1):
      8250_pnp.c: add another Wacom tablet

Graf Yang (1):
      blackfin: Subtract ANOMALY_05000230 on quot

Jiri Slaby (2):
      mxser: remove tty_port_tty_get from mxser_check_modem_status
      tty: moxa, fix refcounting in moxa_poll_port

Matthew Garrett (1):
      serial: Update PNP IDs

Michael Hennerich (1):
      blackfin: BF538/9 serial uart support

Mike Frysinger (1):
      blackfin: Use unsigned long for flags with irq functions

Roel Kluin (1):
      rio: addition has higher precedence than ?:

Scott James Remnant (5):
      riscom8: Auto-load riscom8 module when device opened.
      usb: Auto-load cdc_acm module when device opened.
      specialix: Auto-load specialix module when device opened.
      cyclades: Auto-load cyclades module when device opened.
      applicom: Auto-load applicom module when device opened.

Shawn Bohrer (1):
      8250_pci: add support for National Instruments 843x RS232 devices

Sonic Zhang (2):
      Fix DMA rx ring buffer handling
      blackfin: Fix tty compile error in PIO mode

Will Page (1):
      8250_pci: add support for National Instruments legacy 8420 RS232 boards


 drivers/char/applicom.c           |    1 
 drivers/char/cyclades.c           |    2 
 drivers/char/isicom.c             |    1 
 drivers/char/moxa.c               |    9 -
 drivers/char/mxser.c              |    1 
 drivers/char/rio/rio_linux.c      |    2 
 drivers/char/riscom8.c            |    2 
 drivers/char/specialix.c          |    1 
 drivers/serial/8250_pci.c         |  412 +++++++++++++++++++++++++++++++++++++
 drivers/serial/8250_pnp.c         |    7 +
 drivers/serial/Kconfig            |    2 
 drivers/serial/bfin_5xx.c         |   15 +
 drivers/serial/icom.c             |   14 -
 drivers/serial/jsm/jsm_driver.c   |    9 -
 drivers/serial/jsm/jsm_tty.c      |    4 
 drivers/serial/ucc_uart.c         |    1 
 drivers/usb/class/cdc-acm.c       |    5 
 drivers/usb/serial/pl2303.c       |    1 
 drivers/usb/serial/pl2303.h       |    4 
 drivers/usb/serial/symbolserial.c |   67 ------
 include/linux/pci_ids.h           |   26 ++
 include/linux/serial_core.h       |    2 
 22 files changed, 486 insertions(+), 102 deletions(-)

-- 
Signature
