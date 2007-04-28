Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXD1Npf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXD1Npf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965838AbXD1NoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:44:25 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46408 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbXD1Nkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:40:37 -0400
X-Originating-Ip: 74.109.98.66
Date: Sat, 28 Apr 2007 09:40:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same time?
Message-ID: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
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


  i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
were mutually exclusive when it came to calling kmalloc(), at least
based on everything i'd read.  so i'm not sure how to interpret the
following:

drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);

  clarification?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
