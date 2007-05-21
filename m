Return-Path: <linux-kernel-owner+w=401wt.eu-S1765336AbXEUX0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765336AbXEUX0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbXEUXZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:25:55 -0400
Received: from [216.16.235.2] ([216.16.235.2]:49516 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758130AbXEUXZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:25:54 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 21 May 2007 19:24:57 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: error in recent patch to fs/partitions/ldm.c
Message-ID: <Pine.LNX.4.64.0705211923270.1886@localhost.localdomain>
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


$ git show dde33348e53ecab687a9768bf5262f0b8f79b7f2
...
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
...
-                       (unsigned long long)ph->config_size );
+                       udunsigned long long)ph->config_size);
                        ^^^^^^^^^^

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
