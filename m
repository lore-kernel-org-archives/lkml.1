Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbZEDPjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbZEDPjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbZEDPjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:39:07 -0400
Received: from cantor.suse.de ([195.135.220.2]:40996 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758216AbZEDPjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:39:06 -0400
Date: Mon, 4 May 2009 08:35:25 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.28.10 (ocfs2 build failure)
Message-ID: <20090504153525.GA10910@suse.de>
References: <20090502200413.GA7287@kroah.com> <49FF0A16.904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FF0A16.904@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 08:30:30AM -0700, Randy Dunlap wrote:
> Greg KH wrote:
> > I'm announcing the release of the 2.6.28.10 kernel.
> > 
> > It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
> > series are strongly encouraged to upgrade.  Especially due to the CVE
> > issues that are fixed here.
> > 
> > NOTE, this is the LAST update of the 2.6.28 kernel series, so all users
> > are very strongly encouraged to upgrade to the 2.6.29 series at this
> > point in time!
> 
> Sad.  It shouldn't end with build errors,
> 
> 
> logs/ca-ostest292/kernel.make.log.i386.~2:fs/ocfs2/journal.h:451: error: too many arguments
>  to function 'jbd2_journal_begin_ordered_truncate'
> logs/ca-ostest292/kernel.make.log.i386.~2:make[2]: *** [fs/ocfs2/alloc.o] Error 1
> logs/ca-ostest292/kernel.make.log.i386.~2:fs/ocfs2/journal.h:451: error: too many arguments
>  to function 'jbd2_journal_begin_ordered_truncate'
> logs/ca-ostest292/kernel.make.log.i386.~2:make[2]: *** [fs/ocfs2/aops.o] Error 1
> logs/ca-ostest292/kernel.make.log.i386.~2:fs/ocfs2/journal.h:451: error: too many arguments
>  to function 'jbd2_journal_begin_ordered_truncate'
> logs/ca-ostest292/kernel.make.log.i386.~2:make[2]: *** [fs/ocfs2/buffer_head_io.o] Error 1
> logs/ca-ostest292/kernel.make.log.i386.~2:fs/ocfs2/journal.h:451: error: too many arguments
>  to function 'jbd2_journal_begin_ordered_truncate'
> logs/ca-ostest292/kernel.make.log.i386.~2:make[2]: *** [fs/ocfs2/dir.o] Error 1
> [truncated]

No one ever sent in a patch to fix this :(

Also, it sounded like the config you are building isn't even used by
people, hence no one was willing to fix it...

thanks,

greg k-h
