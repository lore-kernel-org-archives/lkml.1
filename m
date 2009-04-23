Return-Path: <linux-kernel-owner+w=401wt.eu-S1760504AbZDWVgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504AbZDWVgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759026AbZDWVfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:35:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759050AbZDWVfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:35:41 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: [PATCH 0/4] Fix sys_sync() and cleanup code (version 3)
Date: Thu, 23 Apr 2009 23:35:32 +0200
Message-Id: <1240522536-2994-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  this is a next version of the patches. I've modified comments a bit
and mainly fixed a return value of __fsync_super() (forgot to commit
the fix before). Thanks to Trond and Christoph for useful comments.

								Honza
