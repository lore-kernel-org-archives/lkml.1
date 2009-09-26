Return-Path: <linux-kernel-owner+w=401wt.eu-S1752609AbZIZNKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbZIZNKx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 09:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZIZNKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 09:10:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42667 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZIZNKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 09:10:52 -0400
Date: Sat, 26 Sep 2009 09:10:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ferenc Wagner <wferi@niif.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Ray Lee <ray-lk@madrabbit.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Staubach <staubach@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: mmap vs mtime in 2.6.26 and up
Message-ID: <20090926131043.GA25204@infradead.org>
References: <20090518114305.GA6303@infradead.org> <87vdj742dt.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdj742dt.fsf@tac.ki.iif.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 02:47:42PM +0200, Ferenc Wagner wrote:
> I added some fresh test results to
> http://bugzilla.kernel.org/show_bug.cgi?id=2645.  In short, under
> 2.6.30-rc8 the test program reports full failure on XFS and RAMFS,
> full success on EXT3, VFAT and ReiserFS, and mixed results on TMPFS:

There's a patch queued up for inclusion in 2.6.32 to work around this
issue in XFS.  The lack of a proper callout from the VFS still makes
this a much less than ideal solution.

