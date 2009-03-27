Return-Path: <linux-kernel-owner+w=401wt.eu-S1761932AbZC0UZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761932AbZC0UZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 16:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbZC0UYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 16:24:38 -0400
Received: from THUNK.ORG ([69.25.196.29]:45715 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761597AbZC0UYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 16:24:35 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, jack@suse.cz
Subject: [PATCH 0/3] Ext3 latency improvement patches
Date: Fri, 27 Mar 2009 16:24:28 -0400
Message-Id: <1238185471-31152-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches have been posted as providing at least some
partial improvement to the ext3 latency problem that has been
discussed on the 2.6.29 mongo-LKML-thread-that-would-not-die.

I plan to push this to Linus during the 2.6.29 merge window if there
are no huge objections.  It is by no means a complete solution, but it
should at least help the situation somewhat.

It is also available via git:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext3-latency-fixes

Comments?

						- Ted

Jan Kara (1):
      ext3: Avoid starting a transaction in writepage when not necessary

Theodore Ts'o (2):
      block_write_full_page: Use synchronous writes for WBC_SYNC_ALL writebacks
      ext3: Use WRITE_SYNC for commits which are caused by fsync()




