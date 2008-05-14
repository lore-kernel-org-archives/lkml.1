Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbYENR3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbYENR3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYENR2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:28:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752658AbYENR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:28:49 -0400
Date: Wed, 14 May 2008 10:28:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Andreas Gruenbacher <agruen@suse.de>, Tiger Yang <tiger.yang@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] ext3/4: fix uninitialized bs in
 ext3/4_xattr_set_handle()
Message-Id: <20080514102809.3fc190f0.akpm@linux-foundation.org>
In-Reply-To: <20080514160035.GD28594@kroah.com>
References: <4827B878.50903@oracle.com>
	<20080512170254.f79fe869.akpm@linux-foundation.org>
	<4828FD68.40608@oracle.com>
	<200805141256.43272.agruen@suse.de>
	<20080514160035.GD28594@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 09:00:36 -0700 Greg KH <greg@kroah.com> wrote:

> On Wed, May 14, 2008 at 12:56:42PM +0200, Andreas Gruenbacher wrote:
> > On Tuesday 13 May 2008 04:31:04 Tiger Yang wrote:
> > > Hi, Andrew
> > >
> > > This situation only happens we format ext3/4 with inode size more than
> > > 128 and we have put xattr entries both in ibody and block.
> > > The consequences about this bug is we will lost the xattr block which
> > > pointed by i_file_acl with all xattr entires in it. We will alloc a new
> > > xattr block and put that large value entry in it. The old xattr block
> > > will become orphan block.
> > 
> > The patch looks good, and it obviously fixes the described problem. Thanks!
> > 
> > Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> > 
> > 
> > Could it please be added to -stable?
> 
> Can someone actually _send_ the patch to stable@kernel.org?  I haven't
> seen it yet :)
> 
> And is it in Linus's tree?  We need to wait until it is there before we
> can add it to -stable.

It's in -mm and I just added the "Cc:stable" tag to it.
