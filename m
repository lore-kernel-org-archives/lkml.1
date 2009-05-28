Return-Path: <linux-kernel-owner+w=401wt.eu-S1762816AbZE1Bh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762816AbZE1Bh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758514AbZE1Bhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:37:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021AbZE1Bhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:37:46 -0400
Date: Wed, 27 May 2009 17:37:21 -0700
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 01/20] sysfs: Implement sysfs_rename_link
Message-ID: <20090528003721.GB2720@suse.de>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1242865694-2100-1-git-send-email-ebiederm@xmission.com> <20090528001418.GA2499@kroah.com> <ac3eb2510905271730j59af10d6h58d955625324f206@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510905271730j59af10d6h58d955625324f206@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 02:30:15AM +0200, Kay Sievers wrote:
> On Thu, May 28, 2009 at 02:14, Greg KH <greg@kroah.com> wrote:
> >
> > So, there's been a lot of talk in this thread.
> >
> > Eric, do you have an updated set of patches for me to try out?
> 
> I think we should get a version of the patch in that removes all files
> in a directory on cleanup, but warn if a subdirectory is still there.
> James has a patch to fix the one issue we've seen so far with existing
> child directories.
> 
> After that, we should work on fixing the users that leave files
> behind, and can possibly stop cleaning up files, if we want to.

That would be good.

But note that we always "allowed" such things to happen, so odds are
there are lots of places in the kernel that took advantage of this.  If
we make it a rule, people will complain.

> > Or are there still problems, like the "fry the ext3 boot partition" that
> > Kay found?
> 
> That is unrelated to Eric's patches, They just added the dump, which I
> tried to trigger. It's not entirely clear what caused the filesytem
> damage, but I was definitely able to reproduce the unclean shutdown
> without any of Eric's sysfs patches.

Ok.

But I think Eric had some updates to some of the patches along the way,
so a whole new respin would be good to ensure I get the correct ones.

Eric?

thanks,

greg k-h
