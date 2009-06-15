Return-Path: <linux-kernel-owner+w=401wt.eu-S933029AbZFOSSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbZFOSSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbZFOSSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:18:00 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:38917 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533AbZFOSR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:17:59 -0400
Date: Mon, 15 Jun 2009 23:47:53 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, npiggin@suse.de
Subject: Re: [PATCH 0/10] Fix page_mkwrite() for blocksize < pagesize
	(version 3)
Message-ID: <20090615181753.GA26615@skywalker>
References: <1245088797-29533-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245088797-29533-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 07:59:47PM +0200, Jan Kara wrote:
> 
> patches below are an attempt to solve problems filesystems have with
> page_mkwrite() when blocksize < pagesize (see the changelog of the second patch
> for details).
> 
> Could someone please review them so that they can get merged - especially the
> generic VFS/MM part? It fixes observed problems (WARN_ON triggers) for ext4 and
> makes ext2/ext3 behave more nicely (mmapped write getting page fault instead
> of silently discarding data).


Will you be able to send it as two series.

a) One that fix the blocksize < page size bug
b) making ext2/3 mmaped write give better allocation pattern.

Doing that will make sure (a) can go in this merge window. There are
other ext4 fixes waiting for (a) to be merged in.


> 
> The series is against Linus's tree from today. The differences against previous
> version are one bugfix in ext3 delalloc implementation... Please test and review.
> Thanks.

-aneesh
