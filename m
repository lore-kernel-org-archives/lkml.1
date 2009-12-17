Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZLQC4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZLQC4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 21:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZLQC4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 21:56:31 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:43315 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbZLQC4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 21:56:31 -0500
Message-ID: <4B298FC0.8040709@oracle.com>
Date: Wed, 16 Dec 2009 17:56:16 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Alex Elder <aelder@sgi.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.33-rc1
References: <200912162126.nBGLQAbZ012632@stout.americas.sgi.com> <20091216135512.2675a0e3.randy.dunlap@oracle.com> <20091217002007.GF4850@discord.disaster>
In-Reply-To: <20091217002007.GF4850@discord.disaster>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B299DBD.0100:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Wed, Dec 16, 2009 at 01:55:12PM -0800, Randy Dunlap wrote:
>> On Wed, 16 Dec 2009 15:26:10 -0600 Alex Elder wrote:
>>
>>> One more XFS update for -rc1, now that the new XFS tracing code has
>>> been committed.
>> Sorry if I have missed it, but have the printk format warnings
>> on i386 builds been fixed?
> 
> I don't see any here w/ gcc 4.3.4 x86-64 compiling i386 kernels....
> 
> /me hates gcc's warning inconsistencies with a passion.
> 
>> e.g.:
>>
>> In file included from linux-next-20091216/include/trace/ftrace.h:398,
>>                  from linux-next-20091216/include/trace/define_trace.h:69,
>>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.h:1369,
>>                  from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.c:75:
>> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_iomap_enter':
>> linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:830: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'xfs_fsblock_t'
> 
> Patch that should fix this below.

Yes, thanks for that.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


