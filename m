Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015Ab0AVJVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0AVJVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 04:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700Ab0AVJVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 04:21:38 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:40302 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab0AVJVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 04:21:38 -0500
Date: Fri, 22 Jan 2010 14:51:27 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Jan Kiszka <jan.kiszka@siemens.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20100122092127.GB7127@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com> <20091231003808.GC23808@nowhere> <20091231190217.GC3676@in.ibm.com> <20100110031857.GB15195@nowhere> <4B4B78D1.2080606@siemens.com> <20100116194058.GA31079@in.ibm.com> <20100120060159.GA4859@in.ibm.com> <4B596C8E.2020600@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B596C8E.2020600@siemens.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 10:14:54AM +0100, Jan Kiszka wrote:
> K.Prasad wrote:
> > On Sun, Jan 17, 2010 at 01:10:58AM +0530, K.Prasad wrote:
> >> On Mon, Jan 11, 2010 at 08:15:29PM +0100, Jan Kiszka wrote:
> >>> Frederic Weisbecker wrote:
> >>>> On Fri, Jan 01, 2010 at 12:32:17AM +0530, K.Prasad wrote:
> >>>>> On Thu, Dec 31, 2009 at 01:38:09AM +0100, Frederic Weisbecker wrote:
> >>>>>> On Sat, Dec 26, 2009 at 11:58:33PM +0530, K.Prasad wrote:
> >>>>>>> The hw-breakpoint handler will return NOTIFY_DONE for user-space breakpoints
> >>>>>>> to generate SIGTRAP signal (and not for kernel-space addresses). 
> >>>>>>>
<snipped>
> >> Such a behaviour shouldn't be affected by the above change...your
> >> confirmation would help!
> >>
> > 
> > Hi Jan,
> > 	I presume that the above explanation makes the role of this
> > patch/bugfix clear.
> > 
> > Kindly let me know if you have any further queries.
> > 
> 
> Nope. There should be really no conflicts of your optimization with kvm.
> 
> Jan
> 
> -- 

Hi Jan,
	Thanks for the confirmation.

Hi Frederic,
	Can you pull these fixes in? (LKML references:
20091226182725.GB9494@in.ibm.com and 20091226182833.GC9494@in.ibm.com).

Thanks,
K.Prasad

