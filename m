Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbXEMUZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbXEMUZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 16:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbXEMUZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 16:25:04 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36327 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXEMUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 16:25:03 -0400
X-Originating-Ip: 72.143.66.196
Date: Sun, 13 May 2007 16:24:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: undeprecate raw driver.
In-Reply-To: <46476FBF.5010803@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0705131612050.3954@localhost.localdomain>
References: <E1HnHxK-0004CI-00@calista.eckenfels.net>
 <Pine.LNX.4.64.0705131347450.1144@localhost.localdomain>
 <46476FBF.5010803@s5r6.in-berlin.de>
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

On Sun, 13 May 2007, Stefan Richter wrote:

> Except that the term "obsolete" is already used differently in the
> context of Linux kernel features; see Documentation/ABI/README.

no, it isn't.  in fact, it's used in that file *exactly* the way i've
been defining it:

"obsolete/"

"This directory documents interfaces that are still remaining in the
kernel, but are marked to be removed at some later point in time.
The description of the interface will document the reason why it is
obsolete and when it can be expected to be removed. The file
Documentation/feature-removal-schedule.txt may describe some of these
interfaces, giving a schedule for when they will be removed."

  note the salient points of what is considered "obsolete":

* yes, it's still in the kernel
* it may already be scheduled to be removed
* it's documented why that interface is ***obsolete*** and is
scheduled for removal

  look carefully, stefan -- note what's missing from that explanation:
the word "deprecated" which, IMHO, means something quite different.

  at this point, i've explained several times already what i think is
the difference between these two terms, and why i think it's an
*important* difference and how those terms should be used to guarantee
clarity.

  you clearly disagree and there's absolutely nothing i can say at
this point that's going to get through to you and i'm as thoroughly
tired of trying to explain it to you as i'm sure everyone else is of
reading it.  so let's just accept that any further discussion on this
topic is a waste of time.  and we can leave things the way they are,
and things will continue to be mis-labelled and people will, on a
regular basis, continue to submit patches to remove things that claim
to be "obsolete" but which aren't, and this whole freakin' debate will
start all over again.

  happy now?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
