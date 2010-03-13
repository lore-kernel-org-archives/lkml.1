Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218Ab0CMBJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:09:31 -0500
Received: from www.tglx.de ([62.245.132.106]:36100 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936024Ab0CMBJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 20:09:25 -0500
Date: Sat, 13 Mar 2010 02:08:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Subject: Re: [Patch] x86,pat Update the page flags for memtype atomically
 instead of using memtype_lock.
In-Reply-To: <1268439313.2793.148.camel@sbs-t61.sc.intel.com>
Message-ID: <alpine.LFD.2.00.1003130204560.22855@localhost.localdomain>
References: <20100311161700.GC5685@sgi.com> <1268439313.2793.148.camel@sbs-t61.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010, Suresh Siddha wrote:
> On Thu, 2010-03-11 at 08:17 -0800, Robin Holt wrote:
> > Changes since -V1:
> > 1) Introduce atomically setting and clearing the page flags and not
> > using the global memtype_lock to protect page->flags.
> > 
> > 2) This allowed me the opportunity to convert the rwlock back into a
> > spinlock and not affect _MY_ tests performance as all the pages my test
> > was utilizing are tracked by struct pages.
> 
> Can you also include this spinlock to rwlock conversion, which can be
> used for non RAM pages as a second patch?

spinlock -> rwlock conversion ? I hope you meant it the other way
round as Robin said in #2 :)

And yes it should be a separate patch.

Thanks,

	tglx

