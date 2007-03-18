Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbXCRBJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbXCRBJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 21:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXCRBJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 21:09:43 -0400
Received: from gherkin.frus.com ([192.158.254.49]:43889 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbXCRBJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 21:09:42 -0400
Subject: [BUG] no boot with 2.6.21-rc3 and later
To: linux-kernel@vger.kernel.org
Date: Sat, 17 Mar 2007 19:09:41 -0600 (CST)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070318010941.70B46DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Platform is a Dell CPxJ 650GT notebook.  Attempts to boot 2.6.21-rc3
and -rc4 produce the following console output:

(apparently normal boot)
...
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
PIIX4: IDE controller at PCI slot 0000:00:07.1
PIIX4: chipset revision 1
PIIX4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x0860-0x0867, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x0868-0x086f, BIOS settings: hdc:DMA, hdd:pio
(hangs here)

The next two lines of output for 2.6.21-rc2 and earlier are:
Probing IDE interface ide0...
hda: TOSHIBA MK3017GAP, ATA DISK drive

Any idea what's going on here?

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
