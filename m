Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbXDLQem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbXDLQem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXDLQeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:34:11 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50733 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbXDLQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:33:34 -0400
Date: Thu, 12 Apr 2007 12:28:02 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [ PATCH 0/6 ] UML - Finish host file I/O fix, page fault speedup
Message-ID: <20070412162802.GA7260@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These are 2.6.22 material.

The first three finish getting rid of the bogus host file I/O code.
It turns out that all callers of the old code could have just used the
new code.  I don't know why I was unable to log in when I earlier just
did the quick and simple conversion.

Patch 4 removes some debugging code accidentally included in the
rewrite of the page table walking code.

Patch 5 is a bit of deadlock avoidance.

Patch 6 redoes the host side of page fault handling, with a noticable
performance improvement on a kernel build.

				Jeff
-- 
Work email - jdike at linux dot intel dot com
