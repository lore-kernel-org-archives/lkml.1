Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbXGAQR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbXGAQR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXGAQRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:17:48 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43995 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXGAQRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:17:48 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 1 Jul 2007 12:16:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: instrumentation and kprobes really still "EXPERIMENTAL"?
Message-ID: <Pine.LNX.4.64.0707011204580.32355@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  i just noticed that, in the Kconfig files that support KPROBES, both
the "Instrumentation support" menu is still listed as EXPERIMENTAL,
while Kprobes support within is simultaneously dependent on that same
selection.

  for one, that's kind of redundant and, for another, isn't kprobes
mature enough to not be considered experimental anymore?  after all,
red hat is shipping fedora 7 with kprobes support on by default.  that
kind of takes it out of the realm of experimental, doesn't it?

  in addition, while most of the KPROBES config options depend on

  KALLSYMS && EXPERIMENTAL && MODULES

the s390 architecture depends only on

  EXPERIMENTAL && MODULES

and its instrumentation support is *not* listed as experimental.

  also, the avr32 entry is in the file Kconfig.debug, and depends only
on DEBUG_KERNEL.  just an observation.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
