Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbZLPVz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbZLPVz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbZLPVz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:55:56 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:41239 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbZLPVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:55:55 -0500
Date: Wed, 16 Dec 2009 13:55:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alex Elder <aelder@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.33-rc1
Message-Id: <20091216135512.2675a0e3.randy.dunlap@oracle.com>
In-Reply-To: <200912162126.nBGLQAbZ012632@stout.americas.sgi.com>
References: <200912162126.nBGLQAbZ012632@stout.americas.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B29573F.001A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 15:26:10 -0600 Alex Elder wrote:

> One more XFS update for -rc1, now that the new XFS tracing code has
> been committed.

Sorry if I have missed it, but have the printk format warnings
on i386 builds been fixed?


e.g.:

In file included from linux-next-20091216/include/trace/ftrace.h:398,
                 from linux-next-20091216/include/trace/define_trace.h:69,
                 from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.h:1369,
                 from linux-next-20091216/fs/xfs/linux-2.6/xfs_trace.c:75:
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_iomap_enter':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:830: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_iomap_found':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:831: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_iomap_alloc':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:832: warning: format '%llx' expects type 'long long unsigned int', but argument 12 has type 'xfs_fsblock_t'
  LD      drivers/media/IR/ir-common.o
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_exact_done':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1226: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_exact_error':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1227: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_near_nominleft':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1228: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_near_first':  LD      drivers/media/IR/built-in.o

linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1229: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_near_greater':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1230: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_near_lesser':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1231: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_near_error':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1232: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_size_neither':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1233: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_size_noentry':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1234: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_size_nominleft':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1235: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_size_done':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1236: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_size_error':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1237: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_small_freelist':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1238: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_small_notenough':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1239: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_small_done':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1240: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_small_error':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1241: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_vextent_badargs':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1242: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_vextent_nofix':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1243: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_vextent_noagbp':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1244: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_vextent_loopfailed':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1245: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h: In function 'ftrace_raw_output_id_xfs_alloc_vextent_allfailed':
linux-next-20091216/fs/xfs/linux-2.6/./xfs_trace.h:1246: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'


> 					-Alex
> 
> The following changes since commit 5ac4d630eb87656bd4dc313b910776d54d88ea28:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block
> 
> are available in the git repository at:
> 
>   git://oss.sgi.com/xfs/xfs for-linus
> 
> Christoph Hellwig (2):
>       xfs: check for not fully initialized inodes in xfs_ireclaim
>       xfs: kill xfs_bmbt_rec_32/64 types
> 
> Dave Chinner (2):
>       xfs: improve metadata I/O merging in the elevator
>       XFS: Free buffer pages array unconditionally
> 
>  fs/xfs/linux-2.6/xfs_buf.c |   10 +++++++---
>  fs/xfs/linux-2.6/xfs_buf.h |    1 +
>  fs/xfs/xfs_bmap_btree.h    |   14 +++-----------
>  fs/xfs/xfs_iget.c          |   12 ++++++++----
>  fs/xfs/xfs_inode_item.h    |    6 +++---
>  fs/xfs/xfs_log.c           |    2 ++
>  include/linux/fs.h         |    1 +
>  7 files changed, 25 insertions(+), 21 deletions(-)


---
~Randy
