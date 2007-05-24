Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbXEXVIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbXEXVIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750705AbXEXVIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:08:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:50247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXEXVIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:08:43 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Date: Thu, 24 May 2007 23:08:38 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524135513.b6efacbf.akpm@linux-foundation.org> <20070524210103.GA5380@redhat.com>
In-Reply-To: <20070524210103.GA5380@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705242308.38360.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 23:01:04 Dave Jones wrote:
> On Thu, May 24, 2007 at 01:55:13PM -0700, Andrew Morton wrote:
>  > On Wed, 23 May 2007 15:46:37 -0700
>  > Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>  > 
>  > > Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
>  > > will be enabled automatically by current acpi-cpufreq driver and cpufreq.
>  > 
>  > So you're saying that the cpufreq code in Linus's tree aleady supports IDA?
>  > If so, this is a 2.6.22 patch, isn't it?
> 
> From my limited understanding[*], ida is the "We're single threaded,
> disable the 2nd core, and clock the first core faster" magic.
> It doesn't need code-changes, as its all done in hardware afaik.

P0 is somewhat visible to software, but it should be pretty transparent

> 
> identifying & exporting the flags on earlier kernels should be harmless,
> but not really 'mustfix'.

I think it's generally a good idea to push cpuinfo flags in earliest
as possible; just make sure we actually use the final name (so that we don't get
into a pni->sse3 mess again) 
 
-Andi
