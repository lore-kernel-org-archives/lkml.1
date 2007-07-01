Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbXGAMvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbXGAMvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 08:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbXGAMvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 08:51:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33582 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbXGAMvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 08:51:08 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 1 Jul 2007 08:49:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why are some atomic_t's not volatile, while most are?
Message-ID: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>
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


  prompted by the earlier post on "volatile"s, is there a reason that
most atomic_t typedefs use volatile int's, while the rest don't?

$ grep "typedef.*struct"  $(find . -name atomic.h)
./include/asm-v850/atomic.h:typedef struct { int counter; } atomic_t;
./include/asm-mips/atomic.h:typedef struct { volatile int counter; } atomic_t;
./include/asm-mips/atomic.h:typedef struct { volatile long counter; } atomic64_t;
...

  etc, etc.  just curious.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
