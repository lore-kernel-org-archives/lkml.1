Return-Path: <linux-kernel-owner+w=401wt.eu-S1763551AbYBLU0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763551AbYBLU0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYBLUZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:25:55 -0500
Received: from www.tglx.de ([62.245.132.106]:35387 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbYBLUZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:25:55 -0500
Date: Tue, 12 Feb 2008 21:25:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/8] Implement true end_pfn_mapped for 32bit
In-Reply-To: <200802122049.41477.ak@suse.de>
Message-ID: <alpine.LFD.1.00.0802122121030.12988@apollo.tec.linutronix.de>
References: <200802111034.764275766@suse.de> <20080211093435.E6FC21B41CE@basil.firstfloor.org> <alpine.LFD.1.00.0802122035270.12988@apollo.tec.linutronix.de> <200802122049.41477.ak@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Andi Kleen wrote:
> > > @@ -36,7 +36,7 @@
> > >  #define max_pfn_mapped		end_pfn_map
> > >  #else
> > >  #include <asm/page_32.h>
> > > -#define max_pfn_mapped		max_low_pfn
> > > +#define max_pfn_mapped		end_pfn_map
> > 
> > We can nuke either max_pfn_mapped or end_pfn_map completely. I don't
> > care about which one, but keeping both makes no sense at all.
> 
> I didn't want to bundle such a clean up into the bug fix
> because my experience is that you usually reject that categorically.

True, but I apply two separate patches.

> I can send the removal of max_pfn_mapped as a follow up patch
> if you apply this one.

Too late. It was so obvious that it screamed to be fixed. I applied
the inital patch already and cleaned it up myself. :)

Thanks,

	tglx
