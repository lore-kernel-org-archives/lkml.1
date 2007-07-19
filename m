Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbXGSJvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbXGSJvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757249AbXGSJvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:51:06 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43892 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755AbXGSJvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:51:04 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 19 Jul 2007 05:49:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Remove R/W semaphore content from generic semaphore.h
 headers.
In-Reply-To: <Pine.LNX.4.64.0707190530040.19703@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707190546260.20463@localhost.localdomain>
References: <Pine.LNX.4.64.0707190530040.19703@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Robert P. J. Day wrote:

.... blah blah ...

once upon a time, i *did* scan the source tree to verify that any
source file that used a R/W semaphore did, in fact, include the
rwsem.h file, and i found only one file that needed tweaking:

commit ae4472aa03d38b11f334dc0030b82e0c9f249af9
Author: Robert P. J. Day <rpjday@mindspring.com>
Date:   Mon Feb 12 00:51:52 2007 -0800

    [PATCH] QUOTA: Have <linux/quota.h> include <linux/rwsem.h> explicitly

    Since quota.h declares a R/W semaphore, it should include rwsem.h
    explicitly.

    Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
    Acked-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

that suggests that any breakage should be minimal.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
