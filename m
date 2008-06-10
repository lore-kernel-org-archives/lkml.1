Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbYFJXG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbYFJXG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYFJXGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:06:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:37084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbYFJXGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:06:46 -0400
Date: Tue, 10 Jun 2008 16:00:58 -0700
From: Greg KH <gregkh@suse.de>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Benjamin Thery <benjamin.thery@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 00/11] sysfs tagged directories V5
Message-ID: <20080610230058.GA25072@suse.de>
References: <20080606154654.356185262@theryb.frec.bull.fr> <20080610225024.GB22478@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610225024.GB22478@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 05:50:24PM -0500, Serge E. Hallyn wrote:
> Quoting Benjamin Thery (benjamin.thery@bull.net):
> > Greg,
> > 
> > Here is an updated version of the sysfs tagged directories that improves
> > a bit the situation over the previous one. 
> > 
> > I've modified the patch 09 ("Enable tagging for net_class directories in 
> > sysfs") to be a bit less intrusive in sysfs core. I removed the #ifdef'd
> > parts you didn't like in fs/sysfs/mount.c, and replaced it by a generic 
> > routine sysfs_ns_exit() that is called, if needed, by the namespace when
> > it exits. This routine goes through every sysfs super blocks and calls 
> > the callback passed by the namespace to clean its tag.
> > 
> > The patch is now splitted in two: 
> > * 09/11: the generic routine,
> > * 10/11: the remaining network parts.
> > 
> > The generic part can be merge with patch 05 ("sysfs: Implement sysfs 
> > tagged directory support.") but I left it separate for now to ease 
> > reviews.
> 
> Thanks.  Not nearly as radical as I'd feared.
> 
> Greg, does this address your concern?  It stops the need to put any
> non-braindead code (i.e. the _exit notifier stuff) in fs/sysfs/mount.c for
> any new namespaces needing sysfs tagging, leaving only simple
> comparison/assignments.

Sorry, I've been swamped with other things this week and haven't gotten
a chance to look this over.  Hopefully by the end of the week...  It's
in my queue though, don't worry it will not get lost.

thanks,

greg k-h
