Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab0CDXSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 18:18:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab0CDXSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 18:18:45 -0500
Date: Fri, 5 Mar 2010 00:18:54 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] UDF fixes for 2.6.34-rc1
Message-ID: <20100304231853.GD4887@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-udf-2.6.git for_linus

  to get:

Akinobu Mita (1):
      udf: use ext2_find_next_bit

Jan Kara (2):
      udf: Fix unalloc space handling in udf_update_inode
      udf: Do not read inode before writing it

The diffstat is

 fs/udf/balloc.c |   49 +------------------------------------------------
 fs/udf/inode.c  |   34 +++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 65 deletions(-)

							Thanks
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
