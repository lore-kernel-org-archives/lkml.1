Return-Path: <linux-kernel-owner+w=401wt.eu-S2992485AbXCWQJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992485AbXCWQJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992490AbXCWQJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:09:40 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:33844 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992485AbXCWQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:09:40 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 23 Mar 2007 12:06:36 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: header files that are (sort of) referenced
Message-ID: <Pine.LNX.4.64.0703231201530.31459@CPE00045a9c397f-CM001225dbafb6>
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


  based on that last response, i'm curious about which header files
are technically "unreferenced" in the source tree.

  for example, consider the following two closely-related headers:

  linux/if_wanpipe.h
  linux/if_wanpipe_common.h

that second one is not included by any other file in the tree, so i
would normally call that "unused."  but the first one, while also not
included, *is* exported to userspace.

  i haven't given it much thought but it seems odd to me to include a
header file in the source tree that's technically not *used* by
anything in the source tree, only to export it to userspace.  why not
just keep it in userspace in the first place?

  or is that a silly question?

rday

p.s.  i'm going to assume that if_wanpipe_common.h really *is* useless
and i'll be submitting my final dead header file patch shortly.

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
