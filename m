Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbZANHOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbZANHOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZANHOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:14:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758027AbZANHOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:14:07 -0500
Date: Tue, 13 Jan 2009 23:13:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, pavel@ucw.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/10] MAINTAINERS - script, patterns, and misc fixes
Message-Id: <20090113231329.ee0e534f.akpm@linux-foundation.org>
In-Reply-To: <1231907210.7935.527.camel@localhost>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
	<20090113125435.4821123a.akpm@linux-foundation.org>
	<1231907210.7935.527.camel@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009 20:26:50 -0800 Joe Perches <joe@perches.com> wrote:

> On Tue, 2009-01-13 at 12:54 -0800, Andrew Morton wrote:
> > akpm:/usr/src/git26> ../25/scripts/get_maintainer.pl -f mm/filemap.c 
> > Balbir Singh <balbir@linux.vnet.ibm.com>
> > Hugh Dickins <hugh@veritas.com>
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Miklos Szeredi <mszeredi@suse.cz>
> > Nick Piggin <npiggin@suse.de>
> > 
> > I think Balbir would be surprised!
> 
> get_maintainer output is in alphabetical order,
> not ordered by signer frequency.

The latter would be better?

> Balbir Singh is one of the top 5 signers over the last year
> for mm/filemap.c excluding you and Linus.
> 
> $ git log --since=1-year-ago mm/filemap.c | \
> 	grep -P "^ +.*by:" | sort | uniq -c | sort -rn | head
>      38     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>      35     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>      14     Signed-off-by: Nick Piggin <npiggin@suse.de>
>       5     Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>       5     Signed-off-by: Hugh Dickins <hugh@veritas.com>
>       4     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>       4     Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 

I assume there's some remove-akpm rule?  If so, can we please remove
it?  This tool will be used for bug reports and patches - I want to see
those emails!

Thanks.
