Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbXCHA4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbXCHA4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965029AbXCHA4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:56:42 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:47806 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348AbXCHA4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:56:40 -0500
X-Originating-Ip: 74.109.98.130
Date: Wed, 7 Mar 2007 19:44:41 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: the usage of DEBUG_DRIVER seems ambiguous
Message-ID: <Pine.LNX.4.64.0703071941200.14336@CPE00045a9c397f-CM001225dbafb6>
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


  the usage of the DEBUG_DRIVER preprocessor variable is a big
confusing:

$ $ grep -rw DEBUG_DRIVER *
drivers/net/sunlance.c:#undef DEBUG_DRIVER
drivers/net/a2065.c:#ifdef DEBUG_DRIVER
drivers/net/a2065.c:#ifdef DEBUG_DRIVER
drivers/net/7990.c:#ifdef DEBUG_DRIVER
drivers/net/7990.c:#ifdef DEBUG_DRIVER
drivers/base/Kconfig:config DEBUG_DRIVER
...

  it's clearly a configuration variable, but it's also being used by
itself in a few drivers/net/ source files.  is that deliberate?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
