Return-Path: <linux-kernel-owner+w=401wt.eu-S1759942AbYBXQei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759942AbYBXQei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758526AbYBXQe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:34:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:52221 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbYBXQe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:34:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,397,1199692800"; 
   d="scan'208";a="301331955"
Date: Sun, 24 Feb 2008 08:30:41 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>, hch@infradead.org
Subject: Re: [patch 1/2] x86,fpu: split FPU state from task struct
Message-ID: <20080224163041.GC27194@linux-os.sc.intel.com>
References: <20080224023547.264625000@linux-os.sc.intel.com> <20080224072202.GB655@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080224072202.GB655@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 08:22:02AM +0100, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > Split the FPU save area from the task struct. This allows easy 
> > migration of FPU context, and it's generally cleaner. It also allows 
> > the following two optimizations:
> > 
> > 1) only allocate when the application actually uses FPU, so in the 
> > first lazy FPU trap. This could save memory for non-fpu using apps. 
> > Next patch does this lazy allocation.
> > 
> > 2) allocate the right size for the actual cpu rather than 512 bytes 
> > always. Patches enabling xsave/xrstor support (coming shortly) will 
> > take advantage of this.
> 
> i like the concept. Please clean up the issues found by Christoph and 
> please also base it against x86.git#testing [this is clear 2.6.26 
> material and there are already some changes in this area]:
> 
>    http://people.redhat.com/mingo/x86.git/README

Sure. Will do that in a day.

thanks,
suresh
