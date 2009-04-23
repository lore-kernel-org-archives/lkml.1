Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZDWOsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZDWOsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 10:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbZDWOra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 10:47:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbZDWOr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 10:47:27 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/4] Fix sys_sync() bug and cleanup code (version 2)
Date: Thu, 23 Apr 2009 16:47:21 +0200
Message-Id: <1240498045-14288-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  this is a next version of my series of patches to fix sys_sync(). The bug
could result in not all data being safely on disk after sys_sync() returns. It
also fixes the same issue in fsync_super() which leads to assertion failure in
JBD with Jens's per-BDI writeback patches.
  The first patch fixes the data integrity problem, the other three patches are
various cleanups.

									Honza
