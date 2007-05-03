Return-Path: <linux-kernel-owner+w=401wt.eu-S1767577AbXECR4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767577AbXECR4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767586AbXECR4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:56:31 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36679 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767577AbXECR43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:56:29 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 13:56:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: axboe@kernel.dk
Subject: dead CONFIG_ variable under drivers/block
Message-ID: <Pine.LNX.4.64.0705031353580.11320@localhost.localdomain>
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


$ ../dead_config.sh drivers/block
========== MM_MAP_MEMORY ==========
drivers/block/umem.c:109:#ifdef CONFIG_MM_MAP_MEMORY
drivers/block/umem.c:876:#ifdef CONFIG_MM_MAP_MEMORY
drivers/block/umem.c:907:#ifdef CONFIG_MM_MAP_MEMORY
drivers/block/umem.c:925:       printk(KERN_INFO "MM%d: MEM area not remapped (CONFIG_MM_MAP_MEMORY not set)\n",
drivers/block/umem.c:1095:#ifdef CONFIG_MM_MAP_MEMORY
drivers/block/umem.c:1120:#ifdef CONFIG_MM_MAP_MEMORY

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
