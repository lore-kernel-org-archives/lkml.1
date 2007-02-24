Return-Path: <linux-kernel-owner+w=401wt.eu-S933489AbXBXKgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbXBXKgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 05:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933491AbXBXKgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 05:36:20 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:57650 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489AbXBXKgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 05:36:20 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 24 Feb 2007 05:34:15 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: why is asm-parisc/ioctl.h subtly different from asm-generic/ioctl.h?
Message-ID: <Pine.LNX.4.64.0702240530190.11865@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  just noticed that parisc's ioctl.h file, rather than simply
including asm-generic/ioctl.h, has its own copy whose sole
(meaningful) difference from the generic one is:

$ diff include/{asm-generic,asm-parisc}/ioctl.h
...
41,42c54,55
< #define _IOC_WRITE    1U
< #define _IOC_READ     2U
---
> #define _IOC_WRITE    2U
> #define _IOC_READ     1U

 so parisc is identical except that it switches the meaning of the
direction field?  is there a reason for this?  just curious.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
