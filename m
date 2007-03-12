Return-Path: <linux-kernel-owner+w=401wt.eu-S1030664AbXCLRCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030664AbXCLRCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030708AbXCLRCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:02:39 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39000 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030664AbXCLRCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:02:39 -0400
X-Originating-Ip: 74.109.98.130
Date: Mon, 12 Mar 2007 12:59:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: module.h and moduleparam.h:  more header file pedantry
Message-ID: <Pine.LNX.4.64.0703121252430.19315@CPE00045a9c397f-CM001225dbafb6>
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


  well, since my last adventure with header files went over so
swimmingly, i might as well keep going.  :-)

  to my surprise, i learned only today that module.h includes
moduleparam.h, which flies in the face of all of the documentation
i've ever read which was adamant that i *had* to include moduleparam.h
if i was using parameters. i'm guessing this comes as a surprise to
the 400+ header files which include both unnecessarily.

  so ... in a perfect world, should a module source file that doesn't
use parameters *at all* need to include moduleparam.h?  as it stands
now, yes, it does, given some ugly inter-dependencies between the two
files.

  so, at the very least, programmers can stop including moduleparam.h,
unless there's a cleaner way to do all that.

rday


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
