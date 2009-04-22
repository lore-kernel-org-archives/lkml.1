Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZDVP4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZDVP4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 11:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZDVP4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 11:56:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46795 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZDVP4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 11:56:23 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 0/2] Fix sys_sync() bug and slightly cleanup the code
Date: Wed, 22 Apr 2009 17:56:19 +0200
Message-Id: <1240415781-17834-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  this series of two patches fixes a bug in sys_sync() which could result in
not all data being safely on disk after this function returns. It also fixes
the same issue in fsync_super() which leads to assertion failure in JBD with
Jens's per-BDI writeback patches.
  The first patch fixes those two bugs, the second patch just simplifies the
code afterwards.

									Honza
