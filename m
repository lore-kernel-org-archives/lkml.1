Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZCXAQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZCXAQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 20:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZCXAQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 20:16:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39451 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbZCXAP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 20:15:59 -0400
Date: Mon, 23 Mar 2009 17:11:25 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org, mfasheh@suse.com,
       Theodore Tso <tytso@mit.edu>
Subject: Re: Linux 2.6.28.9 (ocfs2 build errors)
Message-ID: <20090324001125.GA22832@suse.de>
References: <20090323220927.GA11563@kroah.com> <49C8226E.9010504@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C8226E.9010504@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 04:59:42PM -0700, Randy Dunlap wrote:
> Greg KH wrote:
> > I'm announcing the release of the 2.6.28.9 kernel.
> > 
> > It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
> > series are strongly encouraged to upgrade.
> > 
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.28.8 and 2.6.28.9
> > 
> > The updated 2.6.28.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.28.y.git
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.28.y.git;a=summary
> 
> 
> fs/ocfs2/journal.h:451: error: too many arguments to function 'jbd2_journal_begin_ordered_truncate'
> 
> (affects many fs/ocfs2/ source files)

Yes, I didn't add Ted's patch yet, as he didn't send it in a form that I
could take it in :(

thanks,

greg k-h
