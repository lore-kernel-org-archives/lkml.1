Return-Path: <linux-kernel-owner+w=401wt.eu-S1762791AbXIUXju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762791AbXIUXju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbXIUXjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:39:43 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50573 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbXIUXjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:39:43 -0400
Subject: Re: [PATCH 07/25] r/o bind mounts: elevate write count for some
	ioctls
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <20070921160314.67b116ed.akpm@linux-foundation.org>
References: <20070920195249.852667D5@kernel>
	 <20070920195257.0E38EED5@kernel>
	 <20070921160314.67b116ed.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 16:39:40 -0700
Message-Id: <1190417980.26982.195.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 16:03 -0700, Andrew Morton wrote:
> Dave Hansen <haveblue@us.ibm.com> wrote:
> 
> > Some ioctl()s can cause writes to the filesystem.  Take
> > these, and make them use mnt_want/drop_write() instead.
> > 
> > We need to pass the filp one layer deeper in XFS, but
> > somebody _just_ pulled it out in February because nobody
> > was using it, so I don't feel guilty for adding it back.
> 
> Note that -mm's ext2-reservations.patch adds EXT2_IOC_SETRSVSZ,
> and it doesn't do mnt_want_write().

That doesn't quite apply to mainline (at least after the patches I just
sent).  I'll wait and send you one on top of the next -mm so that I can
get a coherent view of what's going on if that's all right.

-- Dave

