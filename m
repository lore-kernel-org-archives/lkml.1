Return-Path: <linux-kernel-owner+w=401wt.eu-S1946432AbXBIMsE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946432AbXBIMsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 07:48:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946433AbXBIMsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 07:48:04 -0500
Received: from qb-out-0506.google.com ([72.14.204.238]:46335 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946432AbXBIMsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 07:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ISKNW2bpnRrEIfBYEA1DPN+aHUccZ/cv58EVKfYIoYp489o/KXeaMmE/9SVlCoDTxy61IB+gqOpsUhxrmhdIQQkzrpR7Ihp627xbdmnDnFecqxQkG1dcBKEAf8MTySurfrp890jVHN9jsGhr8YXPpxCrjPwy2HUQZtDwq5Pkjk8=
Message-ID: <1e1a7e1b0702090448l4c1e1f0cs6516056e400acf9f@mail.gmail.com>
Date: Fri, 9 Feb 2007 23:48:00 +1100
From: James <iphitus@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: -mm merge plans for 2.6.21
Cc: "=?ISO-8859-1?Q?Lenar_L=F5hmus?=" <lenar@vision.ee>,
       linux-kernel@vger.kernel.org, "Con Kolivas" <kernel@kolivas.org>
In-Reply-To: <20070209021242.03ba88d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	 <45CC44D5.6050602@vision.ee>
	 <20070209021242.03ba88d8.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/9/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 09 Feb 2007 11:54:29 +0200 Lenar Lõhmus <lenar@vision.ee> wrote:
>
> > Hello,
> >
> > Andrew Morton wrote:
> > > sched-add-above-background-load-function.patch
> > > mm-implement-swap-prefetching.patch
> > > mm-implement-swap-prefetching-vs-zvc-stuff.patch
> > > mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
> > > mm-implement-swap-prefetching-use-ctl_unnumbered.patch
> > > swap_prefetch-vs-zoned-counters.patch
> > > add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
> > > zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
> > > reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
> > > sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
> > > numa-add-zone_to_nid-function-swap_prefetch.patch
> > > remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
> > >
> > >  Hold.
> > Why hold?
> >
> > It's been shown this patchset really helps desktop users.
>
> Has it?  I don't think I've ever observed any benefits from it and I don't
> think anyone has ever got down and worked out what its drawbacks might be,
> and seen if they can be demonstrated in practice.
>

Plenty of people replied with positive reviews when it was posted
earlier. I'd expect that you'd have a fair bit of ram, so you're less
likely to observe any benefit, as you wouldnt be digging into swap as
often as those on lesser systems.

http://lkml.org/lkml/2006/3/23/25

> I also have vague memories of some serious-sounding review comments about
> the code from Nick.

http://lkml.org/lkml/2006/3/23/55

Could that be it? Maybe repoll Con on those.

> > Why keep it in -mm for so long?
>
> I'm waiting to be shown that its benefits exceed its costs.  Sometimes
> that's hard.
>

Con's patchset is used pretty widely now, with many distro's (Arch,
Mandriva, PCLinuxOS among others) providing prebuilt kernels and
nobody has reported any drawbacks. I don't think anyone in -mm has
reported any either.

James
-- 
iphitus // Arch Developer // kernel26beyond // iphitus.loudas.com
