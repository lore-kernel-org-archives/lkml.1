Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXJ2T4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXJ2T4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXJ2T4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:56:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:35270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbXJ2T4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:56:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: 2.6.23 boot failures on x86-64.
Date: Mon, 29 Oct 2007 20:56:00 +0100
User-Agent: KMail/1.9.6
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Ebourne <fedora@ebourne.me.uk>,
       Zou Nan hai <nanhai.zou@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20071029175014.GH7793@redhat.com> <200710292003.09317.ak@suse.de> <20071029194311.GE1650@redhat.com>
In-Reply-To: <20071029194311.GE1650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710292056.01086.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2007 20:43:11 Dave Jones wrote:
> On Mon, Oct 29, 2007 at 08:03:09PM +0100, Andi Kleen wrote:
> 
>  > >  > It's probably the usual "nobody tests sparsemem at all" issue.
>  > > 
>  > > We've been using SPARSEMEM in Fedora for a *long* time.
>  > > So long in fact, I forget why we moved away from DISCONTIGMEM, so there's
>  > > a significant number of users using that configuration for some time.
>  > 
>  > Supposedly you wanted a slower kernel that needs more memory? 
>  > 
>  > Ok I wasn't aware of that. I tended to get sparsemem reports usually
>  > at least 1-2 releases after the fact, so it looked like it was undertested.
> 
> Looking at cvs history, I can't figure out what the reasoning was,
> but every Fedora (and RHEL5) kernel since 2006/07/05 has been that way.
> 
> Curious how no-one noticed either of the side-effects you mention.

It's a few percent on a few benchmarks iirc. vmemmap (now in .24) was supposed
to address that.

-Andi
