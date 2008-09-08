Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYIHRr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYIHRr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYIHRrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:47:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:32858 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbYIHRrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:47:18 -0400
Date: Mon, 8 Sep 2008 10:46:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.26.5
Message-ID: <20080908174604.GA22061@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.26.5
kernel.

It fixes the build error introduced in 2.6.26.4 due to me applying a
stale patch to the tree.  Thanks to David Miller for providing the
correct patch and Randy Dunlap for pointing out my error.

I'll also be replying to this message with a copy of the patch between
2.6.26.4 and 2.6.26.5

The updated 2.6.26.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.26.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                |    2 +-
 include/linux/mroute.h  |   25 ++++---------------------
 include/linux/mroute6.h |    1 +
 include/linux/pim.h     |   27 +++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 22 deletions(-)

Greg Kroah-Hartman (2):
      NET: fix build error caused by Greg K-H
      Linux 2.6.26.5

