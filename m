Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbYEGILN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbYEGILN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbYEGIKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:10:50 -0400
Received: from styx.suse.cz ([82.119.242.94]:53994 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757012AbYEGIKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:10:47 -0400
Date: Wed, 7 May 2008 10:10:46 +0200
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] UDF fixes
Message-ID: <20080507081046.GB27903@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Linus,

  would you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get two bugfixes and one patch I've accidentally ommitted from the
previous merge. Diffstat and shortlog is below. Thanks.

									Honza

 fs/udf/namei.c           |  145 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/udf/partition.c       |    4 -
 fs/udf/super.c           |    1 
 fs/udf/udfdecl.h         |    1 
 include/linux/exportfs.h |   21 ++++++
 5 files changed, 166 insertions(+), 6 deletions(-)

Adrian Bunk (1):
      udf: fs/udf/partition.c:udf_get_pblock() mustn't be inline

Jan Kara (1):
      udf: Fix memory corruption when fs mounted with noadinicb option

Rasmus Rohde (1):
      udf: Make udf exportable

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
