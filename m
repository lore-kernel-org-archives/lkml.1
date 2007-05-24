Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbXEXWLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbXEXWLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbXEXWLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:11:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:9311 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbXEXWLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:11:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,575,1170662400"; 
   d="scan'208";a="231834256"
Date: Thu, 24 May 2007 15:08:23 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Message-ID: <20070524220823.GA8362@linux-os.sc.intel.com>
References: <20070523224637.GB15887@linux-os.sc.intel.com> <20070524150223.41063046.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524150223.41063046.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 03:02:23PM -0700, Andrew Morton wrote:
> On Wed, 23 May 2007 15:46:37 -0700
> Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:
> 
> > Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
> > will be enabled automatically by current acpi-cpufreq driver and cpufreq.
> > 
> > Refer to Intel Software Developer's Manual for more details about the feature.
> > 
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > 
> > Index: linux-2.6.22-rc-mm/arch/i386/kernel/cpu/proc.c
> > ===================================================================
> > --- linux-2.6.22-rc-mm.orig/arch/i386/kernel/cpu/proc.c
> > +++ linux-2.6.22-rc-mm/arch/i386/kernel/cpu/proc.c
> > @@ -41,7 +41,7 @@ static int show_cpuinfo(struct seq_file 
> >  		"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
> >  		NULL, NULL, NULL, NULL,
> >  		"constant_tsc", "up", NULL, NULL, NULL, NULL, NULL, NULL,
> > -		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> > +		"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> >  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> >  
> >  		/* Intel-defined (#2) */
> > Index: linux-2.6.22-rc-mm/arch/x86_64/kernel/setup.c
> > ===================================================================
> > --- linux-2.6.22-rc-mm.orig/arch/x86_64/kernel/setup.c
> > +++ linux-2.6.22-rc-mm/arch/x86_64/kernel/setup.c
> > @@ -949,7 +949,7 @@ static int show_cpuinfo(struct seq_file 
> >  		/* Other (Linux-defined) */
> >  		"cxmmx", NULL, "cyrix_arr", "centaur_mcr", NULL,
> >  		"constant_tsc", NULL, NULL,
> > -		"up", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> > +		"up", NULL, NULL, NULL, "ida", NULL, NULL, NULL,
> >  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> >  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> 
> Ho hum.  This clashes with hpa's git-newsetup tree, which goes for a great
> tromp through the cpuinfo implementation.
> 

Hmm.. Will move feature detection to setup routines and will also
refresh the patch against latest mm and resend it

Thanks,
Venki
 
