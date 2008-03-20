Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYCTGF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYCTGF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 02:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYCTGFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 02:05:15 -0400
Received: from eazy.amigager.de ([213.239.192.238]:60715 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbYCTGFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 02:05:14 -0400
Date: Thu, 20 Mar 2008 07:05:50 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core
	Duo
Message-ID: <20080320060550.GA13200@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

whereas I had working suspend with 2.6.25-rc5, I had a hang at resume
with git HEAD from March 19th (something after 2.6.25-rc6). I tried it
again and got another hang, so it seems to be reproducible.

Any hints what commit might have broke suspend? I won't have the time
to start a git bisect or any resume debugging using CONFIG_PM_TRACE_RTC
until next Tuesday.

This is a Mac mini Core Duo. Here is the lspci -nn output:

00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GM/PM/GMS,
943/940GML and 945GT Express Memory Controller Hub [8086:27a0] (rev 03)

00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
945GM/GMS, 943/940GML Express Integrated Graphics Controller
[8086:27a2] (rev 03)

00:07.0 Performance counters [1101]: Intel Corporation Unknown device
[8086:27a3] (rev 03)

00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family)
High Definition Audio Controller [8086:27d8] (rev 02)

00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI
Express Port 1 [8086:27d0] (rev 02)

00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI
Express Port 2 [8086:27d2] (rev 02)

00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB UHCI Controller #1 [8086:27c8] (rev 02)

00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB UHCI Controller #2 [8086:27c9] (rev 02)

00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB UHCI Controller #3 [8086:27ca] (rev 02)

00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB UHCI Controller #4 [8086:27cb] (rev 02)

00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB2 EHCI Controller [8086:27cc] (rev 02)

00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge
[8086:2448] (rev e2)

00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC
Interface Bridge [8086:27b9] (rev 02)

00:1f.1 IDE interface [0101]: Intel Corporation 82801G (ICH7 Family)
IDE Controller [8086:27df] (rev 02)

00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7
Family) SATA IDE Controller [8086:27c4] (rev 02)

00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus
Controller [8086:27da] (rev 02)

01:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
88E8053 PCI-E Gigabit Ethernet Controller [11ab:4362] (rev 22)

02:00.0 Ethernet controller [0200]: Atheros Communications, Inc. AR242x
802.11abg Wireless PCI Express Adapter [168c:001c] (rev 01)

03:03.0 FireWire (IEEE 1394) [0c00]: Agere Systems FW323 [11c1:5811]
(rev 61)

Regards,
Tino
