Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYGJMyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYGJMyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYGJMya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:54:30 -0400
Received: from sandesh.cdotd.ernet.in ([196.1.105.47]:53058 "EHLO
	sandesh.cdotd.ernet.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbYGJMy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:54:29 -0400
X-Greylist: delayed 2085 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2008 08:54:29 EDT
From: "Prabhat Gupta" <prabhatg@cdotd.ernet.in>
To: linux-kernel@vger.kernel.org
Subject: System Hangs while loading ISICOM module...
Date: Thu, 10 Jul 2008 18:18:26 +0530
Message-Id: <20080710124826.M52865@cdotd.ernet.in>
X-Mailer: Open WebMail 2.51 20050228
X-OriginatingIP: 192.168.1.172 (prabhatg)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-4.5510 TC:1F TRN:24 TV:5.5.1026(16022.007)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:5 C:4 M:4 S:4 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My system configuration is x86_64 GNU/Linux with kernel 2.6.18-53.el5. I have a
Multi-tech ISI card inserted into one of the PCI slots on my PC. I compile the driver
(isicom.c available with the kernel source) and try to load it using insmod. The system
hangs after insmod. I added some prints and found that the system hanged in the
following line in the function :

static int __devinit reset_card() when the card is being given a reset by writing 0x0
i.e. in the line  outw(0, base + 0x8); /* Reset */. I am not able to find a solution to
it. When I comment this line, the system doesn't hang but the driver loading fails in
static int __devinit load_firmware() by giving warning "Card1 rejected load header,
Address:0x8000, Count:0x10, Status:0xdd"

Any suggestion would be of immense help to me. Thanks in advance.

Regards,
Prabhat

