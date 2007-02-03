Return-Path: <linux-kernel-owner+w=401wt.eu-S1946389AbXBCIAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946389AbXBCIAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 03:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946390AbXBCIAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 03:00:24 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:38015 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946389AbXBCIAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 03:00:23 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 3 Feb 2007 02:49:34 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: a quick survey:  "FIELD_SIZEOF" or "MEMBER_SIZE"?
Message-ID: <Pine.LNX.4.64.0702030243350.23432@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  pardon the interruption but, once upon a time, we were discussing
cleaning up code to use the kernel.h-defined macro "FIELD_SIZEOF".

  some folks suggested that the macro name itself was kind of awkward
as it didn't fit the pattern of "ARRAY_SIZE" defined in that same
header file.

  because of a name clash, "FIELD_SIZE" is not available, but there
was a suggestion of, uh, "MEMBER_SIZE".  :-)

  so, really, those are the two viable choices -- stick with the
current name of FIELD_SIZEOF, or switch to MEMBER_SIZE.  switching is
not a big deal since no one (at least, no one in the current tree)
uses FIELD_SIZEOF as it is, so it's not as if it would be a disruptive
change in the slightest.

  opinions?

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
