Return-Path: <linux-kernel-owner+w=401wt.eu-S1946295AbXBIKMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946295AbXBIKMq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946299AbXBIKMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:12:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41326 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946295AbXBIKMo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:12:44 -0500
Date: Fri, 9 Feb 2007 02:12:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lenar =?ISO-8859-1?B?TPVobXVz?= <lenar@vision.ee>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-Id: <20070209021242.03ba88d8.akpm@linux-foundation.org>
In-Reply-To: <45CC44D5.6050602@vision.ee>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<45CC44D5.6050602@vision.ee>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 11:54:29 +0200 Lenar Lõhmus <lenar@vision.ee> wrote:

> Hello,
> 
> Andrew Morton wrote:
> > sched-add-above-background-load-function.patch
> > mm-implement-swap-prefetching.patch
> > mm-implement-swap-prefetching-vs-zvc-stuff.patch
> > mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
> > mm-implement-swap-prefetching-use-ctl_unnumbered.patch
> > swap_prefetch-vs-zoned-counters.patch
> > add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
> > zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
> > reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
> > sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
> > numa-add-zone_to_nid-function-swap_prefetch.patch
> > remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
> >
> >  Hold.
> Why hold?
> 
> It's been shown this patchset really helps desktop users.

Has it?  I don't think I've ever observed any benefits from it and I don't
think anyone has ever got down and worked out what its drawbacks might be,
and seen if they can be demonstrated in practice.

I also have vague memories of some serious-sounding review comments about
the code from Nick.

> Why keep it in -mm for so long?

I'm waiting to be shown that its benefits exceed its costs.  Sometimes
that's hard.

