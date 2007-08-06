Return-Path: <linux-kernel-owner+w=401wt.eu-S1759544AbXHFGqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544AbXHFGqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbXHFGpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:45:13 -0400
Received: from mail.cs.umn.edu ([128.101.34.202]:47811 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192AbXHFGpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:45:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18102.49987.641303.943970@gargle.gargle.HOWL>
Date: Mon, 6 Aug 2007 01:44:19 -0500
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] /proc/pid/pagemap fixes
X-Mailer: VM 7.19 under Emacs 21.4.1
From: boutcher@cs.umn.edu (Dave Boutcher)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Matt, this patch set replaces the two patches I sent earlier and
contains additional fixes.  I've done some reasonably rigorous testing
on x86_64, but not on a 32 bit arch.  I'm pretty sure this isn't worse
than what's in mm right now, which has some user-space corruption and
a nasty infinite kernel loop. YMMV.

Patch set is against 2.6.23-rc1-mm2.

Dave B
