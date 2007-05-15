Return-Path: <linux-kernel-owner+w=401wt.eu-S1760740AbXEOH76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbXEOH76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 03:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759564AbXEOH7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 03:59:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:40151 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759447AbXEOH7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 03:59:43 -0400
X-Originating-Ip: 72.143.66.196
Date: Tue, 15 May 2007 03:59:03 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why both "__pure" and "__attribute_pure__"?
Message-ID: <Pine.LNX.4.64.0705150353590.19109@localhost.localdomain>
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


  is there a reason that compiler-gcc.h defines both:

#define __pure                          __attribute__((pure))
#define __attribute_pure__              __attribute__((pure))

one would think that the shorter form would be preferable to go along
with the other short forms defined in that header file, but a quick
tree scan shows that the longer form is used exclusively (although
still not in what you'd call overwhelming numbers):

$ grep -rw __attribute_pure__ * | wc -l
17
$ grep -rw __pure * | wc -l
1

  is there any reason not to just change those few instances to the
short form?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
