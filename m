Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbZAWT5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbZAWT5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZAWT5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:57:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:35215 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbZAWT5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:57:22 -0500
Date: Fri, 23 Jan 2009 13:56:05 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm fixes for 2.6.29-rc2
Message-ID: <20090123195605.GB20139@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull two dlm fixes for 2.6.29-rc2 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

They both fix bugs with nfs posix locks on gfs2/ocfs2.  The first is triggered
by a posix lock that overlaps another, the second is triggered by any GETLK,
so both are pretty common.
Thanks,
Dave

David Teigland (1):
      dlm: fix plock notify callback to lockd

Jeff Layton (1):
      dlm: initialize file_lock struct in GETLK before copying conflicting lock

 fs/dlm/plock.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

