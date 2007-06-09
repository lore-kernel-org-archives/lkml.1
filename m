Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbXFIJ0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbXFIJ0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 05:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbXFIJ0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 05:26:46 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37533 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbXFIJ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 05:26:45 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 9 Jun 2007 05:25:08 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel/module.c warning re: non-GPL modules looks wrong
Message-ID: <Pine.LNX.4.64.0706090521250.28643@localhost.localdomain>
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


  from kernel/module.c:
...
        ks = lookup_symbol(name, __start___ksymtab_gpl_future,
                                 __stop___ksymtab_gpl_future);
        if (ks) {
                if (!gplok) {
                        printk(KERN_WARNING "Symbol %s is being used "
                          "by a non-GPL module, which will not "
                          "be allowed in the future\n", name);
                        printk(KERN_WARNING "Please see the file "
                          "Documentation/feature-removal-schedule.txt "
                          "in the kernel source tree for more "
                          "details.\n");
...

  but there's nothing in the feature removal file that expands on that
issue.  (there *is* an entry regarding *unused* symbols, but that
doesn't seem to address the above.)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
