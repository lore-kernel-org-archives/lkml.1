Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbZFOSEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbZFOSEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933214AbZFOSCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:02:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35823 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbZFOSCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:02:37 -0400
Date: Mon, 15 Jun 2009 20:02:39 +0200
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 0/10] Fix page_mkwrite() for blocksize < pagesize (version 3)
Message-ID: <20090615180239.GA3289@atrey.karlin.mff.cuni.cz>
References: <1245088797-29533-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245088797-29533-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> patches below are an attempt to solve problems filesystems have with
> page_mkwrite() when blocksize < pagesize (see the changelog of the second patch
> for details).
> 
> Could someone please review them so that they can get merged - especially the
> generic VFS/MM part? It fixes observed problems (WARN_ON triggers) for ext4 and
> makes ext2/ext3 behave more nicely (mmapped write getting page fault instead
> of silently discarding data).
> 
> The series is against Linus's tree from today. The differences against previous
> version are one bugfix in ext3 delalloc implementation... Please test and review.
> Thanks.
  Sorry for the wrong patch numbering [x/11]. There are really just 10
patches in the series. The eleventh one is just a debugging patch I
don't want to merge.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
