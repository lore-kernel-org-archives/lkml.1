Return-Path: <linux-kernel-owner+w=401wt.eu-S1765701AbYCDTwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765701AbYCDTwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYCDTwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:52:21 -0500
Received: from mail.suse.de ([195.135.220.2]:44866 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbYCDTwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:52:19 -0500
Date: Tue, 4 Mar 2008 11:24:36 -0800
From: Greg KH <gregkh@suse.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, Holger Kiehl <Holger.Kiehl@dwd.de>,
       linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, mingo@elte.hu
Subject: Re: sysfs: duplicate filename '74' can not be created
Message-ID: <20080304192435.GA5525@suse.de>
References: <20080304160940.GC19059@localhost.sw.ru> <20080304163339.GA11160@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304163339.GA11160@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 10:03:39PM +0530, Dhaval Giani wrote:
> On Tue, Mar 04, 2008 at 07:09:40PM +0300, Alexey Dobriyan wrote:
> > [Cc'ing /sys/kernel/uids guys]
> > 
> 
> [Also adding gregkh to the cc :)]
> 
> > > Mar  3 13:50:01 helena kernel: sysfs: duplicate filename '74' can not be created
> > > Mar  3 13:50:01 helena kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()
> > > Mar  3 13:50:01 helena kernel: Pid: 21911, comm: sshd Not tainted 2.6.24.3 #1

What kernel version is this?  2.6.24 had lots of "issues" with the uids
code, I'm amazed it worked at all :)

2.6.25-rc should have this all fixed up, if not, please let me know.

thanks,

greg k-h
