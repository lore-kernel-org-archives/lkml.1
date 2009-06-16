Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZFPK2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZFPK2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 06:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZFPK2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 06:28:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:40294 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbZFPK2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 06:28:23 -0400
Date: Tue, 16 Jun 2009 12:28:23 +0200
From: Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 0/10] Fix page_mkwrite() for blocksize < pagesize
	(version 3)
Message-ID: <20090616102823.GA12577@duck.suse.cz>
References: <1245088797-29533-1-git-send-email-jack@suse.cz> <20090615181753.GA26615@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615181753.GA26615@skywalker>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Mon 15-06-09 23:47:53, Aneesh Kumar K.V wrote:
> On Mon, Jun 15, 2009 at 07:59:47PM +0200, Jan Kara wrote:
> > 
> > patches below are an attempt to solve problems filesystems have with
> > page_mkwrite() when blocksize < pagesize (see the changelog of the second patch
> > for details).
> > 
> > Could someone please review them so that they can get merged - especially the
> > generic VFS/MM part? It fixes observed problems (WARN_ON triggers) for ext4 and
> > makes ext2/ext3 behave more nicely (mmapped write getting page fault instead
> > of silently discarding data).
> 
> Will you be able to send it as two series.
> 
> a) One that fix the blocksize < page size bug
> b) making ext2/3 mmaped write give better allocation pattern.
> 
> Doing that will make sure (a) can go in this merge window. There are
> other ext4 fixes waiting for (a) to be merged in.
  Of course, there is no problem in merging just patches 2, 4 which are
needed for ext4, and leave the rest for the next merge window. Actually,
I'd rather leave at least ext3 patch for the next merge window because that
has the highest chance of breaking something...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
