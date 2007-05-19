Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbXESEK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbXESEK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 00:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXESEKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 00:10:19 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:34043 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXESEKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 00:10:18 -0400
X-Originating-Ip: 72.143.65.211
Date: Sat, 19 May 2007 00:09:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why only one use of "create_freezeable_workqueue"?
Message-ID: <Pine.LNX.4.64.0705190003410.16887@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.42, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	SARE_SUB_OBFU_Q0 0.30, TW_RK 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  hoping to avoid the madness following my earlier, innocuous question
about the lonely, defconfig'ed module scsi_wait_scan.ko, i'm curious
about why there is, in the entire tree, just one invocation of
"create_freezeable_workqueue":

$ grep -rw create_freezeable_workqueue *
drivers/misc/tifm_core.c:       workqueue = create_freezeable_workqueue("tifm");
include/linux/workqueue.h:#define create_freezeable_workqueue(name) __create_workqueue((name), 1, 1)
$

  not that there's anything wrong with that, but i'm just curious as
to why there's only one application of that feature in the whole tree.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
