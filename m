Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab0CIQ2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 11:28:10 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57314 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752581Ab0CIQ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 11:28:08 -0500
Date: Tue, 9 Mar 2010 17:28:04 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc1
Message-ID: <20100309162804.GB7373@atrey.karlin.mff.cuni.cz>
References: <alpine.LFD.2.00.1003081204510.3669@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003081204510.3669@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's out there now. I still have a few trees I already got pull requests 
> for, and that I want to look over a bit more (ceph, gdb tree etc), and 
> it's possible that I've just overlooked some other pull request.
  It seems you haven't pulled my UDF tree (requested on Thursday -
http://lkml.indiana.edu/hypermail/linux/kernel/1003.0/02186.html).
  I've rebased the tree on top of 2.6.34-rc1 so could you please pull
now?
  The full pull request for your convenience:

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

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
