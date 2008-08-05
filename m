Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbYHEJ54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbYHEJ54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbYHEJzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:55:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754097AbYHEJzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:55:04 -0400
Date: Tue, 5 Aug 2008 02:54:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Horman <horms@verge.net.au>
Cc: kexec@lists.infradead.org, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: kdump, ia64: always reserve elfcore header memory in crash
 kernel
Message-Id: <20080805025442.d4626d40.akpm@linux-foundation.org>
In-Reply-To: <20080805094825.GA9712@verge.net.au>
References: <20080805094825.GA9712@verge.net.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 19:48:27 +1000 Simon Horman <horms@verge.net.au> wrote:

> elfcore header memory needs to be reserved in a crash kernel.
> This means that the relevant code should be protected
> by CONFIG_CRASH_DUMP rather than CONFIG_PROC_VMCORE.
> 
> Signed-off-by: Simon Horman <horms@verge.net.au>
> 
> --- 
> Andrew, this patch fixes bug in the (unlikely) case where
> an ia64 crashdump kernel does not have CONFIG_PROC_FS set.
> I think it is worth including in 2.6.27. But breakage cases are
> likely to be minimal to non-existent, so I am comfortable
> with post 2.6.27 too.
> 
> This patch should be appended to the series,
> "is_kdump_kernel() cleanup and related patches".

hm, that means that we would need to apply a moderate-size seven patch
series to fix one little bug.

I think that if we want to fix this in 2.6.27 then the basic single
patch would be preferable.  Or we leave it until 2.6.28/


