Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbZD0RGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbZD0RGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZD0RGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:06:05 -0400
Received: from thunk.org ([69.25.196.29]:42026 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZD0RGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:06:03 -0400
Date: Mon, 27 Apr 2009 13:05:28 -0400
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
       Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
Message-ID: <20090427170528.GD6781@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andi Kleen <ak@linux.intel.com>, Huang Ying <ying.huang@intel.com>,
	Robert Richter <robert.richter@amd.com>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com> <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com> <1240553210.6842.871.camel@yhuang-dev.sh.intel.com> <20090424100943.GJ27264@erda.amd.com> <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com> <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com> <49F5646F.4000305@linux.intel.com> <alpine.DEB.2.00.0904271027580.24293@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904271027580.24293@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 10:39:29AM -0400, Steven Rostedt wrote:
> > > > it is processed before I can release the code.
> > > 
> > > When will it be merged by mainline kernel? Do you have a plan?
> > 
> > Patent applications tend to be measured in years. Also I'm not sure
> > we really want patented algorithms in the kernel anyways if it can
> > be avoided. So the patent probably makes it impractical to use this
> > thing at all.
> 
> Once it is filed then I can post it, I do not need to wait till it is 
> done.

Simply preparing a patent application for filing can take a
non-trivial amount of time.  I'd suggest that you should ask your
patent attorney whether he is planning on filing internationally, or
just in the US.  

If he (or she) is only planning only in the US, unlike the rest of the
world, the US is not a first-to-file, so as long as you have proof of
when you invented it --- for example, getting a description of your
invention notarized --- you might be able to get clearance from your
legal department to submit the patch while the patent application is
getting prepared.

Reference:
	http://en.wikipedia.org/wiki/First_to_file_and_first_to_invent

If your attorney is not willing to do this, all I can suggest is that
you ask him to ask his opposite numbers at other open source companies
how they handle this situation at a future Linux Foundation Legal
Summit.  I can assure you there are far more rational ways of handling
this than forcing people to wait until the patent application is
actually filed.

> And what the hell do you mean about not using patents?? We have several 
> patents in the kernel. Have you ever heard of the Open Invention Network?
> 
>  http://www.openinventionnetwork.com/
> 
> This patent will go under the Open Source patent pool to help 
> protect against patent attacks against Linux, et. al.
> 
> Yes, the Open Source community can file their own patents. The more 
> patents owned by the Open Source community, the better.

No argument here.  It's just that there are better ways of doing
things than waiting until after the patent application is fully
drafted, all of the engineering drawings are done, the language of
patent claims are fine-tuned, etc., all of which can take a long, LONG
time, depending on how busy your patent attorney and his (or her)
staff might happen to be.

      		       	    	 	- Ted
