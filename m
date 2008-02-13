Return-Path: <linux-kernel-owner+w=401wt.eu-S933738AbYBMRDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933738AbYBMRDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932990AbYBMRDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:03:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880AbYBMRDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:03:01 -0500
Date: Wed, 13 Feb 2008 09:00:41 -0800
From: Greg KH <gregkh@suse.de>
To: Pekka Pietikainen <pp@ee.oulu.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
Message-ID: <20080213170041.GC10129@suse.de>
References: <20080213070215.GA11969@kroah.com> <20080213103014.GA5518@ee.oulu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213103014.GA5518@ee.oulu.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:30:14PM +0200, Pekka Pietikainen wrote:
> On Tue, Feb 12, 2008 at 11:02:15PM -0800, Greg KH wrote:
> > This changeset does just that.  Turns out that this makes things more
> > readable, as it's easier to look at a list of filenames for things than
> > picking through a 300 line text file.
> 
> Hmm.. While you're at it, would it make sense to encode the "When"
> into the filename? Like 2010-09-sys_sysctl or 2.6.26-feature-X.

Well why stop there?  Why not put the name of the person and the full
description also in the file?  :)

Seriously, a simple grep works fine here.

> Requires renaming when something is given more time to live, though.
> On the positive side, I think it'd help in keeping these current. 2.6.24
> has e.g.
> 
> What:   PCMCIA control ioctl (needed for pcmcia-cs [cardmgr, cardctl])
> When:   November 2005
> 
> If the date/release has been reached and the feature hasn't been removed
> either more time is added or the feature gets removed.

This has already been discussed a number of times on lkml before, please
see those threads.

thanks,

greg k-h
