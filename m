Return-Path: <linux-kernel-owner+w=401wt.eu-S1759608AbZDJJIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608AbZDJJIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758456AbZDJJH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:07:56 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:34326 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZDJJHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:07:55 -0400
Date: Fri, 10 Apr 2009 09:58:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Yuri Tikhonov <yur@emcraft.com>, Paul Mackerras <paulus@samba.org>,
       yanok@emcraft.com, prodyuth@gmail.com, jwboyer@linux.vnet.ibm.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc: allow 256kB pages with SHMEM
In-Reply-To: <20090409163403.e82ec1c3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0904100945270.2593@blonde.anvils>
References: <Pine.LNX.4.64.0904062151250.21044@blonde.anvils>
 <Pine.LNX.4.64.0904062156290.21044@blonde.anvils>
 <20090409163403.e82ec1c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009, Andrew Morton wrote:
> On Mon, 6 Apr 2009 22:01:15 +0100 (BST)
> Hugh Dickins <hugh@veritas.com> wrote:
> 
> > Now that shmem's divisions by zero and SHMEM_MAX_BYTES are fixed,
> > let powerpc 256kB pages coexist with CONFIG_SHMEM again.
> > 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > ---
> > Added linuxppc-dev and some other Cc's for this 3/3: sorry
> > if you didn't see 1/3 and 2/3, they were just in mm/shmem.c.
> 
> Do we think these patches should be in 2.6.30?

I think so - 2.6.30 will have the rest of Yuri's 256kB page support.
But it would be nice to have an Ack from Yuri before sending these
on through.  2/3 is a bugfix justified even without 256kB pages -
I should have inverted the ordering.

Hugh
