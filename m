Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbZD0Ojn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbZD0Ojn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZD0Ojc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:39:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbZD0Ojb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:39:31 -0400
Date: Mon, 27 Apr 2009 10:39:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <ak@linux.intel.com>
cc: Huang Ying <ying.huang@intel.com>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
In-Reply-To: <49F5646F.4000305@linux.intel.com>
Message-ID: <alpine.DEB.2.00.0904271027580.24293@gandalf.stny.rr.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>  <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>  <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>  <20090424100943.GJ27264@erda.amd.com> 
 <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com> <49F5646F.4000305@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 27 Apr 2009, Andi Kleen wrote:

> Huang Ying wrote:
> > On Fri, 2009-04-24 at 21:36 +0800, Steven Rostedt wrote:
> > > On Fri, 24 Apr 2009, Robert Richter wrote:
> > > > > It seems that ring_buffer is not NMI-safe, while mcelog buffer will be
> > > > > used in NMI context and interrupt context. When will ring_buffer to be
> > > > > NMI-safe?
> > > > You can use it in nmi context with separate read and write
> > > > buffers. See this patch description:
> > > > 6dad828b76c7224a22ddc9ce7aa495d994f03b31
> > > > 
> > > > Not sure if somebody will make the ring_buffer non-locking.
> > > It already is ;-)
> > > 
> > > I've put in for a patent application on the algorithm so I must wait till
> > > it is processed before I can release the code.
> > 
> > When will it be merged by mainline kernel? Do you have a plan?
> 
> Patent applications tend to be measured in years. Also I'm not sure
> we really want patented algorithms in the kernel anyways if it can
> be avoided. So the patent probably makes it impractical to use this
> thing at all.

Once it is filed then I can post it, I do not need to wait till it is 
done.

And what the hell do you mean about not using patents?? We have several 
patents in the kernel. Have you ever heard of the Open Invention Network?

 http://www.openinventionnetwork.com/

This patent will go under the Open Source patent pool to help 
protect against patent attacks against Linux, et. al.

Yes, the Open Source community can file their own patents. The more 
patents owned by the Open Source community, the better.

-- Steve

