Return-Path: <linux-kernel-owner+w=401wt.eu-S934731AbXGRVhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731AbXGRVhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758653AbXGRVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:37:46 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60910 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096AbXGRVhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:37:45 -0400
Message-ID: <469E8822.7000104@garzik.org>
Date: Wed, 18 Jul 2007 17:37:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: new ext4 build warnings
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems jbd_debug() might need modification:

fs/ext4/inode.c: In function ‘ext4_write_inode’:
fs/ext4/inode.c:2906: warning: comparison is always true due to limited 
range of data type

fs/jbd2/recovery.c: In function ‘jbd2_journal_recover’:
fs/jbd2/recovery.c:254: warning: comparison is always true due to 
limited range of data type
fs/jbd2/recovery.c:257: warning: comparison is always true due to 
limited range of data type

fs/jbd2/recovery.c: In function ‘jbd2_journal_skip_recovery’:
fs/jbd2/recovery.c:301: warning: comparison is always true due to 
limited range of data type

I'm surprised this was not noticed in a test build before pushing upstream.

	Jeff


