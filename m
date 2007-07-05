Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbXGEL36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbXGEL36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbXGEL3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:29:50 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43883 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbXGEL3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:29:49 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 5 Jul 2007 07:27:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead(?) i386-related CONFIG variables
Message-ID: <Pine.LNX.4.64.0707050726110.12036@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  since it's not clear who a single contact person would be for
i386-related stuff like this, here's what my script turned up for
tests on non-existent CONFIG variables under arch/i386:

========== BALANCED_IRQ_DEBUG ==========
arch/i386/kernel/io_apic.c:356:#ifdef CONFIG_BALANCED_IRQ_DEBUG
========== DEBUG_PAGE_TYPE ==========
arch/i386/kernel/vmi.c:238:#ifdef CONFIG_DEBUG_PAGE_TYPE
========== SERIAL_DETECT_IRQ ==========
arch/i386/kernel/legacy_serial.c:18:#ifdef CONFIG_SERIAL_DETECT_IRQ

  feel free to take this as seriously as you want.  :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
