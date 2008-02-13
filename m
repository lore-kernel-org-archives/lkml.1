Return-Path: <linux-kernel-owner+w=401wt.eu-S933923AbYBMRwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923AbYBMRwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbYBMRwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:52:24 -0500
Received: from mail.suse.de ([195.135.220.2]:39972 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765897AbYBMRwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:52:24 -0500
Date: Wed, 13 Feb 2008 09:47:59 -0800
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-ID: <20080213174759.GB19653@suse.de>
References: <20080213070215.GA11969@kroah.com> <20080212.230423.172781444.davem@davemloft.net> <1202887323.3129.10.camel@localhost> <20080213165924.GB10129@suse.de> <1202923995.3129.26.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202923995.3129.26.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 09:33:15AM -0800, Joe Perches wrote:
> On Wed, 2008-02-13 at 08:59 -0800, Greg KH wrote:
> > > I suggest the same for MAINTAINERS
> > Why, is it a merge problem for you?
> 
> $ git-log --pretty=oneline --name-only | \
>   grep -vP "[a-fA-F0-9]{40,40}\s" | sort | uniq -c | sort -rbn
>     541 MAINTAINERS
>     506 kernel/sched.c
>     374 drivers/scsi/libata-core.c
>     343 include/linux/sched.h
>     340 include/linux/libata.h
>     327 drivers/net/tg3.c
>     327 drivers/net/sky2.c
>     309 mm/page_alloc.c
>     304 drivers/ata/libata-core.c
>     296 Makefile
> 
> MAINTAINERS is the most frequently patched file

But does it cause merge conflicts?  The size of it lends itself to no
real conflicts that I have run into over time, but others might have had
problems, that's why I'm asking.

> It's not kept in alphabetic order

You can send patches to fix this :)

> It's not easy to find the appropriate maintainer for a specific file

git does a better job of this at times :)

> I'd like to add file patterns to MAINTAINERS entries

I thought we had gone over this before...

thanks,

greg k-h
