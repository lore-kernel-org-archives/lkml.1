Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZANE0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZANE0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZANEZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:25:55 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2988 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159AbZANEZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:25:54 -0500
Subject: Re: [PATCH 0/10] MAINTAINERS - script, patterns, and misc fixes
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, pavel@ucw.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20090113125435.4821123a.akpm@linux-foundation.org>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
	 <20090113125435.4821123a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 20:26:50 -0800
Message-Id: <1231907210.7935.527.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 12:54 -0800, Andrew Morton wrote:
> akpm:/usr/src/git26> ../25/scripts/get_maintainer.pl -f mm/filemap.c 
> Balbir Singh <balbir@linux.vnet.ibm.com>
> Hugh Dickins <hugh@veritas.com>
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Miklos Szeredi <mszeredi@suse.cz>
> Nick Piggin <npiggin@suse.de>
> 
> I think Balbir would be surprised!

get_maintainer output is in alphabetical order,
not ordered by signer frequency.

Balbir Singh is one of the top 5 signers over the last year
for mm/filemap.c excluding you and Linus.

$ git log --since=1-year-ago mm/filemap.c | \
	grep -P "^ +.*by:" | sort | uniq -c | sort -rn | head
     38     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
     35     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
     14     Signed-off-by: Nick Piggin <npiggin@suse.de>
      5     Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
      5     Signed-off-by: Hugh Dickins <hugh@veritas.com>
      4     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
      4     Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

> My script generates what I consider to be better results:
> 
> akpm:/usr/src/25> who-maintains.sh mm/filemap.c
> Nick Piggin <npiggin@suse.de>
> Hugh Dickins <hugh@veritas.com>
> Fengguang Wu <wfg@mail.ustc.edu.cn>
> Christoph Hellwig <hch@lst.de>
> Steven Whitehouse <swhiteho@redhat.com>
> Zach Brown <zach.brown@oracle.com>
> Miklos Szeredi <mszeredi@suse.cz>
> Jan Kara <jack@suse.cz>
> Balbir Singh <balbir@linux.vnet.ibm.com>
> Badari Pulavarty <pbadari@us.ibm.com>
> 
> For some (git related) reason it is vastly slower than yours.

I think the major reason is your script is using all git history.
get_maintainer.pl is using just the last calendar year.


