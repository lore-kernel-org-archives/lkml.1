Return-Path: <linux-kernel-owner+w=401wt.eu-S932604AbXFFPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbXFFPQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 11:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759680AbXFFPQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 11:16:05 -0400
Received: from er-systems.de ([85.25.136.202]:34515 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759689AbXFFPQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 11:16:04 -0400
Date: Wed, 6 Jun 2007 17:16:00 +0200 (CEST)
From: Thomas Voegtle <tv@lio96.de>
To: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>
Subject: 2.6.16.52 can't boot on Intel DG965SS
Message-ID: <Pine.LNX.4.63.0706061436190.32355@er-systems.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="425052808-825119858-1181142960=:32355"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--425052808-825119858-1181142960=:32355
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi,

I want to use 2.6.16.y on the Intel DG965SS mainboard, but the kernel 
stops booting:

...
ACPI: bus type pci registered
PCI: Using MMCONFIG
ACPI: Subsystem revision 20060127
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: Assume root bridge [\_SB_.PCIO] bus is 0 



A Kernel 2.6.16.52 boots with pci=nommconf.
A SuSE 10.1 installation cd boots with no special bootparams.
A Kernel 2.6.17 vanilla boots with no special bootparams.


So something is missing in 2.6.16.y, can anyone point me to a patch or 
something else which enables this?

I know I cannot use PATA of this board, but this does not matter (and 
the e1000 driver is too old).


      Thomas

-- 
 Thomas Vögtle    email: thomas@voegtle-clan.de
 ----- http://www.voegtle-clan.de/thomas ------
--425052808-825119858-1181142960=:32355--
