Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbXFGMaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbXFGMaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 08:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbXFGMaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 08:30:06 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43977 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbXFGMaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 08:30:05 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 7 Jun 2007 08:28:23 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: why is it called "asm-generic/atomic.h"?
Message-ID: <Pine.LNX.4.64.0706070822590.17588@localhost.localdomain>
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


  i'm just curious -- why does that particular header file have that
name?  its opening comment reads:

 * Allows to provide arch independent atomic definitions without the need to
 * edit all arch specific atomic.h files.

but that's *not* what that header file does.  rather, it simply
defines the "long" form of the atomic operations that can be used *in
addition to* the arch-specific ones.

  wouldn't it make more sense to have called that header file
something like "asm-generic/atomic_long.h", so as not to mislead folks
into thinking it represented an *alternative* to those other header
files?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
