Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0BWTF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 14:05:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab0BWTF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 14:05:56 -0500
Date: Tue, 23 Feb 2010 14:05:52 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH] VFS: Simplify truncate logic in do_filp_open()
Message-ID: <20100223190551.GA6377@shell>
References: <20100222203551.GE972@shell> <20100222210827.GF30031@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100222210827.GF30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:08:27PM +0000, Al Viro wrote:
> On Mon, Feb 22, 2010 at 03:35:51PM -0500, Valerie Aurora wrote:
> > The fact that may_open() could truncate a file gave me a lot of
> > heartburn when working on union mounts, so I was thrilled to see that
> > truncate handling has been moved out of may_open() in Al's for-next
> > tree.  However, it seems to me that the surrounding elaborate
> > mnt_want_write() dance is no longer needed?  If so, this also
> > simplifies Ogawa Hirofumi "Fix use-after-free of vfsmount by
> > mnt_drop_write()" patch.
> > 
> > Against Al's for-next branch.  Lightly tested, please review.
> 
> Val, anything around do_filp_open() should be on top of #untested.  The
> whole area gets rewritten there.

Nice!  That's a huge improvement.  I will happily rebase.

Thanks,

-VAL
