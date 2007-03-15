Return-Path: <linux-kernel-owner+w=401wt.eu-S1422943AbXCOQYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422943AbXCOQYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422948AbXCOQYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:24:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422943AbXCOQYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:24:02 -0400
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
From: Steven Whitehouse <swhiteho@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Mark Fasheh <mark.fasheh@oracle.com>
In-Reply-To: <20070315043642.GF15069@wotan.suse.de>
References: <20070314112529.13798.35417.sendpatchset@linux.site>
	 <20070314112540.13798.97719.sendpatchset@linux.site>
	 <20070315041329.GB21942@ca-server1.us.oracle.com>
	 <20070315043642.GF15069@wotan.suse.de>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Thu, 15 Mar 2007 16:24:27 +0000
Message-Id: <1173975867.32601.96.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2007-03-15 at 05:36 +0100, Nick Piggin wrote:
> On Wed, Mar 14, 2007 at 09:13:29PM -0700, Mark Fasheh wrote:
[some comments snipped]
> > Attached is a quick patch to hook up the existing ocfs2 write code. This has
> > been compile tested only for now - one of my test machines isn't
> > cooperating, so a runtime test will have to wait until tommorrow.
> > 
> > One interesting side effect is that we no longer pass AOP_TRUNCATE_PAGE up a
> > level. This gives callers less to deal with. And it means that ocfs2 doesn't
> > have to use the ocfs2_*_lock_with_page() cluster lock variants in
> > ocfs2_block_write_begin() because it can order cluster locks outside of the
> > page lock there.
> 
> OK that's very cool. I was hoping that would be the case. If GFS2 can
> avoid that too, then we might be able to get rid of AOP_TRUNCATE_PAGE
> handling from the legacy prepare/commit_write paths, which will make
> them simpler.
> 
Yes, I agree that with the new operations GFS2 should also no longer
need AOP_TRUNCATE_PAGE for writes,

Steve.


