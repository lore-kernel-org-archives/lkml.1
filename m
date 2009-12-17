Return-Path: <linux-kernel-owner+w=401wt.eu-S934844AbZLQDlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844AbZLQDlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 22:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756912AbZLQDlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 22:41:19 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60198 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756609AbZLQDlS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 22:41:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [GIT PULL] XFS update for 2.6.33-rc1
Date: Wed, 16 Dec 2009 21:41:12 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A687F@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20091217002007.GF4850@discord.disaster>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [GIT PULL] XFS update for 2.6.33-rc1
Thread-Index: Acp+rtLinScZ3n6tRT+GK2bBC3GDjQAG4H0A
From: "Alex Elder" <aelder@sgi.com>
To: "Dave Chinner" <david@fromorbit.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
Cc: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       <xfs@oss.sgi.com>, <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Wed, Dec 16, 2009 at 01:55:12PM -0800, Randy Dunlap wrote:
>> On Wed, 16 Dec 2009 15:26:10 -0600 Alex Elder wrote:
>> 
>>> One more XFS update for -rc1, now that the new XFS tracing code has
>>> been committed.
>> 
>> Sorry if I have missed it, but have the printk format warnings
>> on i386 builds been fixed?
> 
> I don't see any here w/ gcc 4.3.4 x86-64 compiling i386 kernels....

I didn't get them either when I built in my environment.

Dave, your patch looks good to me, and Randy has acked it
so I'm going to pull it into our XFS top-of-tree.  I'll
hold off sending yet another pull request to Linus for
now.  Thanks for addressing it quickly.

					-Alex


> /me hates gcc's warning inconsistencies with a passion.
> 
>> e.g.:
>> 
>> In file included from linux-next-20091216/include/trace/ftrace.h:398,
>>                  from linux-next-20091216/include/trace/define_trace.h:69,
>>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.h:1369,
>>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.c:75:
>> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function
>> 'ftrace_raw_output_id_xfs_iomap_enter': linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:830:
>> warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type
>> 'xfs_fsblock_t'  
> 
> Patch that should fix this below.
> 
> Cheers,
> 
> Dave.

