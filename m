Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbZCQU5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbZCQU5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 16:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbZCQU5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 16:57:45 -0400
Received: from kroah.org ([198.145.64.141]:35692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754324AbZCQU5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 16:57:44 -0400
Date: Tue, 17 Mar 2009 13:55:18 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>, tytso@mit.edu
Cc: Greg KH <gregkh@suse.de>, mfasheh@suse.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.28.8 (ocfs2 build failure)
Message-ID: <20090317205518.GA4442@kroah.com>
References: <20090317012028.GA32410@kroah.com> <49C00787.6060401@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C00787.6060401@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 01:26:47PM -0700, Randy Dunlap wrote:
> Enable all possible OCFS2 kconfig options:
> 
> 
> 
> In file included from fs/ocfs2/alloc.c:42:
> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
>   CC [M]  fs/ocfs2/buffer_head_io.o
> In file included from fs/ocfs2/aops.c:42:
> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
> make[2]: *** [fs/ocfs2/aops.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> In file included from fs/ocfs2/buffer_head_io.c:37:
> fs/ocfs2/journal.h: In function 'ocfs2_begin_ordered_truncate':
> fs/ocfs2/journal.h:451: warning: passing argument 1 of 'jbd2_journal_begin_ordered_truncate' from incompatible pointer type
> fs/ocfs2/journal.h:451: warning: passing argument 2 of 'jbd2_journal_begin_ordered_truncate' makes integer from pointer without a cast
> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
> make[2]: *** [fs/ocfs2/buffer_head_io.o] Error 1
> make[2]: *** [fs/ocfs2/alloc.o] Error 1

Did this show up in 2.6.28.7?

Odds are it's one of the jbd2 patches from Ted.  Ted, any ideas?

thanks,

greg k-h
