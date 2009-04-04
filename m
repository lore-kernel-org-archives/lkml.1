Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZDDRjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZDDRjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 13:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZDDRjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 13:39:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZDDRjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 13:39:39 -0400
Date: Sat, 4 Apr 2009 13:39:36 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org
Subject: Re: [PATCH 10/41] FS-Cache: Add use of /proc and presentation of
	statistics [ver #48]
Message-ID: <20090404173936.GA21189@infradead.org>
References: <20090403155436.28714.23368.stgit@warthog.procyon.org.uk> <20090403155528.28714.19141.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090403155528.28714.19141.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 04:55:28PM +0100, David Howells wrote:
> Make FS-Cache create its /proc interface and present various statistical
> information through it.  Also provide the functions for updating this
> information.
> 
> These features are enabled by:
> 
> 	CONFIG_FSCACHE_PROC
> 	CONFIG_FSCACHE_STATS
> 	CONFIG_FSCACHE_HISTOGRAM
> 
> The /proc directory for FS-Cache is also exported so that caching modules can
> add their own statistics there too.
> 
> The FS-Cache module is loadable at this point, and the statistics files can be
> examined by userspace:
> 
> 	cat /proc/fs/fscache/stats
> 	cat /proc/fs/fscache/histogram

I thought we didn't want to use procfs for these kinds of things
anymore.

