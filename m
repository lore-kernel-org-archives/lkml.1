Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYJQT2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYJQT2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 15:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbYJQT2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 15:28:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50688 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755407AbYJQT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 15:28:14 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/3] Small series of further hardware updates
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 17 Oct 2008 20:27:53 +0100
Message-ID: <20081017192309.9308.74370.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for break on/off to the EPCA driver, thanks to Digi providing
the needed firmware info. It also adds a pile of OxSemi devices to the 8250_pci
drivers, these being the 'Tornado' series adapters. They actually have a pile
of additional functionality it would be nice to support but this simply teaches
the kernel to recognize them and identify them nicely.
---

Alan Cox (1):
      epca: Add infinite break support

Lee Howard (2):
      8250: Add more OxSemi devices
      8250: Oxford Semiconductor Devices


 drivers/char/epca.c          |    6 +
 drivers/parport/parport_pc.c |   20 +++-
 drivers/serial/8250_pci.c    |  231 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h      |    8 +
 4 files changed, 263 insertions(+), 2 deletions(-)

-- 
"Intel sued Cyrix five times and they never won. Intel they just love lawsuits"
		--  Wen Chi Chen, Via's CEO

