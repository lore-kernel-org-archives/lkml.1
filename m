Return-Path: <linux-kernel-owner+w=401wt.eu-S1764738AbXJPMQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764738AbXJPMQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 08:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbXJPMQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 08:16:00 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:39326 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755501AbXJPMP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 08:15:59 -0400
X-Belgacom-Dynamic: yes
Date: Tue, 16 Oct 2007 14:21:51 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: linux-kernel@vger.kernel.org
Subject: Linux v2.6.24 Watchdog Device Drivers patches
Message-ID: <20071016122151.GA606@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Work and personal issues prevented me in being faster in sending out this e-mail.
Sorry for that.

Concerning the watchdog device drivers: this is what is still out to be merged:
1) Move the watchdog device drivers from drivers/char/watchdog to drivers/watchdog.
(Unless someone objects). We do this to make it conform with the other type of
drivers (like hwmon, i2c, parport, ...)
2) The Uniform watchdog device driver is in the -mm tree since +-19 August. I still
need to ask a number of people to review the code before I want to release it.
I also need to document it properly before it get's released.
3) iTCO_wdt.c -> add additional ICH8 PCI-ID's, clean-up pci-device-id-table, ...
4) change naming of IPC SBC Watchdog Timer Driver (used to be wafer but the driver
runs on several IPC boards).
5) AR7 Watchdog Timer
6) Improvements on Documentation/watchdog/src/watchdog-simple.c.
7) Watchdog driver for the Atmel AT91SAM9xx range of processors (After review).
8) SBC Nano 7240 Watchdog Timer (After review).

If someone has objections or when I missed something: please let me know.

Thanks,
Wim.

(Note: for people that want to look at the Uniform Watchdog Device Driver: please see
the code in the linux-2.6-watchdog-mm git tree at:
http://git.kernel.org/?p=linux/kernel/git/wim/linux-2.6-watchdog-mm.git;a=summary )

