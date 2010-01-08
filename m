Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249Ab0AHRpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0AHRpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804Ab0AHRpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:45:01 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:37061 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0AHRpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:45:00 -0500
Date: Fri, 8 Jan 2010 09:44:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Alex Elder" <aelder@sgi.com>
Cc: "Dave Chinner" <david@fromorbit.com>, <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <xfs@oss.sgi.com>,
       <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] XFS update for 2.6.33-rc1
Message-Id: <20100108094428.ff03c720.randy.dunlap@oracle.com>
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A687F@cf--amer001e--3.americas.sgi.com>
References: <20091217002007.GF4850@discord.disaster>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A687F@cf--amer001e--3.americas.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.4B476F04.00D7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 21:41:12 -0600 Alex Elder wrote:

> Dave Chinner wrote:
> > On Wed, Dec 16, 2009 at 01:55:12PM -0800, Randy Dunlap wrote:
> >> On Wed, 16 Dec 2009 15:26:10 -0600 Alex Elder wrote:
> >> 
> >>> One more XFS update for -rc1, now that the new XFS tracing code has
> >>> been committed.
> >> 
> >> Sorry if I have missed it, but have the printk format warnings
> >> on i386 builds been fixed?
> > 
> > I don't see any here w/ gcc 4.3.4 x86-64 compiling i386 kernels....
> 
> I didn't get them either when I built in my environment.
> 
> Dave, your patch looks good to me, and Randy has acked it
> so I'm going to pull it into our XFS top-of-tree.  I'll
> hold off sending yet another pull request to Linus for
> now.  Thanks for addressing it quickly.
> 
> 					-Alex

Hi Alex,
Dave's patch is now needed in Linus's mainline kernel tree...


> > /me hates gcc's warning inconsistencies with a passion.
> > 
> >> e.g.:
> >> 
> >> In file included from linux-next-20091216/include/trace/ftrace.h:398,
> >>                  from linux-next-20091216/include/trace/define_trace.h:69,
> >>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.h:1369,
> >>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.c:75:
> >> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function
> >> 'ftrace_raw_output_id_xfs_iomap_enter': linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:830:
> >> warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type
> >> 'xfs_fsblock_t'  
> > 
> > Patch that should fix this below.
> > 
> > Cheers,
> > 
> > Dave.


---
~Randy
