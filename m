Return-Path: <linux-kernel-owner+w=401wt.eu-S1765499AbXGUTXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765499AbXGUTXY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXGUTXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:23:16 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:50058 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbXGUTXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:23:14 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 21 Jul 2007 15:21:25 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: from where comes "__moddi3"?
Message-ID: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  again, probably displaying my abject ignorance, but i wrote a
trivial module that tries to "var % 15", and i get:

  WARNING: "__moddi3" undefined!

and, not surprisingly, when i try to insmod:

  insmod: error inserting 'seq.ko': -1 Unknown symbol in module

(using 16 rather than 15 works fine, as i assume that the modulus
call is simply replaced by an optimized  bitwise comparison.)

  so ... from where comes __moddi3?  i know there are places in the
kernel source tree that do non-power-of-2 moduli, and they work fine,
no?  thanks.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
