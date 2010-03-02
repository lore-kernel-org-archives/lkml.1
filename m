Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab0CBR1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:27:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:56324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab0CBR1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:27:48 -0500
Date: Tue, 2 Mar 2010 18:27:57 +0100
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jan Kara <jack@suse.cz>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: build failure after merge of the ext3 tree
Message-ID: <20100302172757.GE3829@quack.suse.cz>
References: <20100302113634.2c7f5e03.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302113634.2c7f5e03.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Tue 02-03-10 11:36:34, Stephen Rothwell wrote:
> After merging the ext3 tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/jfs/jfs_xtree.c: In function 'xtSplitRoot':
> fs/jfs/jfs_xtree.c:1256: error: 'rec' undeclared (first use in this function)
> 
> Caused by commit bff3333e868578990f6fe794a7cba0c74bd433ac ("dquot:
> cleanup space allocation / freeing routines").
> 
> This is annoying ... this file system could be build tested on any
> architecture, so why wasn't it?
  I'm sorry. It's my fault. I've modified Christoph's patch but I forgot to
enable JFS in the test build. Since this isn't the first time something
like this happened to me, I've changed the way I commit patches. They'll
first go to for_testing branch and after a build machine runs them through
allyesconfig and allmodconfig compiles they'll get moved to for_next
branch. So hopefully stupid mistakes like this one should be avoided for
future.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
