Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbZAVNsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbZAVNsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbZAVNse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:48:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:39828 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852AbZAVNse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:48:34 -0500
Date: Thu, 22 Jan 2009 14:48:32 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mfasheh@suse.de, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] OCFS2 quota fix
Message-ID: <20090122134832.GB10714@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Linus,

  could you please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-quota-2.6.git for_linus

  to get fixes for OCFS2 quotas:
Jan Kara (2):
      quota: Improve locking
      ocfs2: Remove ocfs2_dquot_initialize() and ocfs2_dquot_drop()

 fs/dquot.c               |  218 ++++++++++++++++++++++++++---------------------
 fs/ocfs2/quota_global.c  |  169 ------------------------------------
 include/linux/quotaops.h |    2 
 3 files changed, 124 insertions(+), 265 deletions(-)

 I'm including also the OCFS2 change because without that fix OCFS2 would
not compile.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
