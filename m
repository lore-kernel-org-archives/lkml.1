Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbYHEKOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbYHEKOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 06:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757748AbYHEKOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 06:14:18 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51796 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbYHEKOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 06:14:17 -0400
Date: Tue, 5 Aug 2008 20:14:15 +1000
From: Simon Horman <horms@verge.net.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: kdump, ia64: always reserve elfcore header memory in crash
	kernel
Message-ID: <20080805101411.GA18192@verge.net.au>
References: <20080805094825.GA9712@verge.net.au> <20080805025442.d4626d40.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080805025442.d4626d40.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 02:54:42AM -0700, Andrew Morton wrote:
> On Tue, 5 Aug 2008 19:48:27 +1000 Simon Horman <horms@verge.net.au> wrote:
> 
> > elfcore header memory needs to be reserved in a crash kernel.
> > This means that the relevant code should be protected
> > by CONFIG_CRASH_DUMP rather than CONFIG_PROC_VMCORE.
> > 
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > --- 
> > Andrew, this patch fixes bug in the (unlikely) case where
> > an ia64 crashdump kernel does not have CONFIG_PROC_FS set.
> > I think it is worth including in 2.6.27. But breakage cases are
> > likely to be minimal to non-existent, so I am comfortable
> > with post 2.6.27 too.
> > 
> > This patch should be appended to the series,
> > "is_kdump_kernel() cleanup and related patches".
> 
> hm, that means that we would need to apply a moderate-size seven patch
> series to fix one little bug.
> 
> I think that if we want to fix this in 2.6.27 then the basic single
> patch would be preferable.  Or we leave it until 2.6.28/

I think it would be better to wait until 2.6.28 than mess around
with a minimal and then a proper fix. I doubt that anyone is hitting
this.
