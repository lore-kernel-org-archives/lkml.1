Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752913AbYLRGOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbYLRGOU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYLRGOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:14:06 -0500
Received: from ozlabs.org ([203.10.76.45]:58511 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbYLRGOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:14:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/4] cpumask: cpu_coregroup_mask(): x86
Date: Thu, 18 Dec 2008 16:44:00 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@redhat.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Jack Steiner <steiner@sgi.com>
References: <200812011646.35018.rusty@rustcorp.com.au> <4949831B.2000809@sgi.com>
In-Reply-To: <4949831B.2000809@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812181644.00796.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008 09:24:19 Mike Travis wrote:
> Rusty Russell wrote:
> > Like cpu_coregroup_map, but returns a (const) pointer.
> > 
> > (This will go to Ingo separately as part of the x86 series, just
> > airing it here for thoroughness).
> > 
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Mike Travis <travis@sgi.com>
> > Cc: Ingo Molnar <mingo@redhat.com>
> 
> I've pulled this patch into the queue for my cpus4096-for-ingo tree.
> 
> 	[PATCH 1/4] cpumask: cpu_coregroup_mask(): x86
> 
> I can also line up a queue for sched related changes:
> 
> 	[PATCH 4/4] cpumask: Replace cpu_coregroup_map with cpu_coregroup_map()
> 
> Is there any status on the corresponding changes for sparc, s390?  (I assume
> that they'll need to be merged into linux-next?)
> 
> 	[PATCH 2/4] cpumask: cpu_coregroup_mask(): sparc
> 	[PATCH 3/4] cpumask: cpu_coregroup_mask(): s390

You can't take 4/4 until 2/4 and 3/4 are merged, and since it's not
x86-specific as well, we'll leave it in my tree.

Thanks,
Rusty.
