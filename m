Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYEODuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYEODuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 23:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYEODt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 23:49:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbYEODt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 23:49:56 -0400
Date: Wed, 14 May 2008 20:49:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Lang <Michael.Lang@jackal-net.at>
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Kernel Panic when accessing NFS share and locking files
Message-Id: <20080514204932.13243cab.akpm@linux-foundation.org>
In-Reply-To: <482B2108.4090902@jackal-net.at>
References: <482B2108.4090902@jackal-net.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 19:27:36 +0200 Michael Lang <Michael.Lang@jackal-net.at> wrote:

> Hi,
> 
> we encountered a serious problem, when using Solaris NFS (Server) 
> accessing it with a CentOS5.1/RHEL5.1 client.
> There are more occurrences of the problem, one i felt over when tried to 
> recreate a different one was, that a unprivileged
> User is able to Kernel Panic a machine with a few lines of code. I 
> tested it with the result that 3 threads requesting a lock
> on the same file already cause the kernel panic. Since this is my first 
> kernel bug request, and it's at least for my understandig
> a security problem, i will provide the code for recreation to a closed 
> group only. Please point me to the right group ...
> 
> Call Trace:
>   [<ffffffff80012323>] __fput+0x94/0x198
>   [<ffffffff8002e2d2>] sys_fcntl+0x2d0/0x2dc
>   [<ffffffff8005b28d>] tracesys+0xd5/0xe0
>  Code: 0f 0b 68 8a de 28 80 c2 c7 07 48 89 c3 48 8b 03 48 85 c0 75
>  RIP  [<ffffffff80027073>] locks_remove_flock+0xe4/0x122
>  RSP <ffff81000be87e48>

Which kernel version is being used?
