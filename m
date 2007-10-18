Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbXJRHtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbXJRHtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 03:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbXJRHtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 03:49:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47624 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932578AbXJRHtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 03:49:05 -0400
Date: Thu, 18 Oct 2007 00:48:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: jeffm@suse.com, hch@lst.de, mason@suse.com, vs@namesys.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: + reiserfs-fix-up-lockdep-warnings.patch added to -mm tree
Message-Id: <20071018004840.3447e5d0.akpm@linux-foundation.org>
In-Reply-To: <1192691425.27435.159.camel@twins>
References: <200710172211.l9HMBnCr010855@imap1.linux-foundation.org>
	<1192691425.27435.159.camel@twins>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 09:10:25 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2007-10-17 at 15:11 -0700, akpm@linux-foundation.org wrote:
> 
> > Subject: reiserfs: fix up lockdep warnings
> > From: Jeff Mahoney <jeffm@suse.com>
> > 
> > Add I_MUTEX_XATTR annotations to the inode locking in the reiserfs xattr code.
> > 
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Chris Mason <mason@suse.com>
> > Cc: "Vladimir V. Saveliev" <vs@namesys.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Yep looks good,
> 
> want me to push this through the lockdep tree, or will you forward it?
> 
> In which case:
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I'll handle it, thanks.

I thought that Linus merged it but it seems not.  hrm.
