Return-Path: <linux-kernel-owner+w=401wt.eu-S1760230AbYCFGML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230AbYCFGML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbYCFGL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:11:57 -0500
Received: from ns2.suse.de ([195.135.220.15]:56130 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbYCFGL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:11:57 -0500
Date: Wed, 5 Mar 2008 22:00:38 -0800
From: Greg KH <gregkh@suse.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Holger Kiehl <Holger.Kiehl@dwd.de>,
       linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: sysfs: duplicate filename '74' can not be created
Message-ID: <20080306060038.GA5574@suse.de>
References: <20080304160940.GC19059@localhost.sw.ru> <20080304163339.GA11160@linux.vnet.ibm.com> <20080304192435.GA5525@suse.de> <20080305085922.GA8951@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305085922.GA8951@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 02:29:22PM +0530, Dhaval Giani wrote:
> On Tue, Mar 04, 2008 at 11:24:36AM -0800, Greg KH wrote:
> > On Tue, Mar 04, 2008 at 10:03:39PM +0530, Dhaval Giani wrote:
> > > On Tue, Mar 04, 2008 at 07:09:40PM +0300, Alexey Dobriyan wrote:
> > > > [Cc'ing /sys/kernel/uids guys]
> > > > 
> > > 
> > > [Also adding gregkh to the cc :)]
> > > 
> > > > > Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
> > > > > Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > > > Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1
> > 
> > What kernel version is this?  2.6.24 had lots of "issues" with the uids
> > code, I'm amazed it worked at all :)
> > 
> 
> :). Seems to be a stable series kernel (2.6.24.3). Can you please tell
> me some of the issues, so that I can try to go fix it up.

Ick, there were a lot of them.  Take a look at the changes to
kernel/user.c (I think that was the file).  A lot of the work was
reworking it due to the kobject changes, but at the same time lots of
code was fixed.

It is a harmless warning, everything should still work properly, right?

thanks,

greg k-h
