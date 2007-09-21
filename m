Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbXIUXsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbXIUXsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbXIUXsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:48:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755792AbXIUXsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:48:08 -0400
Date: Fri, 21 Sep 2007 16:47:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 07/25] r/o bind mounts: elevate write count for some
 ioctls
Message-Id: <20070921164754.8fc03ab1.akpm@linux-foundation.org>
In-Reply-To: <1190417980.26982.195.camel@localhost>
References: <20070920195249.852667D5@kernel>
	<20070920195257.0E38EED5@kernel>
	<20070921160314.67b116ed.akpm@linux-foundation.org>
	<1190417980.26982.195.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 16:39:40 -0700
Dave Hansen <haveblue@us.ibm.com> wrote:

> On Fri, 2007-09-21 at 16:03 -0700, Andrew Morton wrote:
> > Dave Hansen <haveblue@us.ibm.com> wrote:
> > 
> > > Some ioctl()s can cause writes to the filesystem.  Take
> > > these, and make them use mnt_want/drop_write() instead.
> > > 
> > > We need to pass the filp one layer deeper in XFS, but
> > > somebody _just_ pulled it out in February because nobody
> > > was using it, so I don't feel guilty for adding it back.
> > 
> > Note that -mm's ext2-reservations.patch adds EXT2_IOC_SETRSVSZ,
> > and it doesn't do mnt_want_write().
> 
> That doesn't quite apply to mainline (at least after the patches I just
> sent).  I'll wait and send you one on top of the next -mm so that I can
> get a coherent view of what's going on if that's all right.
> 

Sure, that's OK.

But I only noticed it because I happened to have my nose in there fixing a
reject.

