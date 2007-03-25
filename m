Return-Path: <linux-kernel-owner+w=401wt.eu-S1750757AbXCYNYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757AbXCYNYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 09:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbXCYNYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 09:24:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37442 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbXCYNYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 09:24:08 -0400
X-Originating-Ip: 74.109.98.130
Date: Sun, 25 Mar 2007 09:20:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: some PCMCIA SCSI drivers can be built *only* as modules
Message-ID: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.157, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, SARE_OBFU_TION_SUB 0.64)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/scsi/pcmcia/Kconfig:
...
config PCMCIA_AHA152X
        tristate "Adaptec AHA152X PCMCIA support"
        depends on m && !64BIT
        select SCSI_SPI_ATTRS
        help
          Say Y here if you intend to attach this type of PCMCIA SCSI host
          adapter to your computer.

          To compile this driver as a module, choose M here: the
          module will be called aha152x_cs.
...

  it would seem to make no sense that the "depends on" clause for this
option includes "m", forcing this (and all other four entries in that
Kconfig file, by the way) to be built as modules, while the help text
for all five entries suggests you can select "y".

  as jack nicholson would say, something's gotta give.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
