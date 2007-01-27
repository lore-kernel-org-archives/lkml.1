Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXA0Ib2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXA0Ib2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbXA0Ib2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:31:28 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:44365 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbXA0Ib1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:31:27 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 27 Jan 2007 03:31:02 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: definite OMAP1610_IR-related typo
Message-ID: <Pine.LNX.4.64.0701270326550.1000@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_NF 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  not sure what to do with this, it's all yours:

========== OMAP1610_IR ==========
./arch/arm/mach-omap1/devices.c:#if     defined(CONFIG_OMAP1610_IR) || defined(CONFIG_OMAP161O_IR_MODULE)
========== OMAP161O_IR ==========
./arch/arm/mach-omap1/devices.c:#if     defined(CONFIG_OMAP1610_IR) || defined(CONFIG_OMAP161O_IR_MODULE)

  note first that one of those config vars has an "oh" while the other
has a *zero*.  i'm pretty sure that's bad.

  in any event, there's no such config variable of *either* spelling
in any Kconfig file, but there *is* a more all-encompassing
CONFIG_OMAP16XX confguration setting.

-- 

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
