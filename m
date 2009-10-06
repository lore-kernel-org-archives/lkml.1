Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbZJFPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbZJFPez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbZJFPew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:34:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35149 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880AbZJFPev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:34:51 -0400
Subject: Re: Linux 2.6.32-rc3
From: Dirk Hohndel <hohndel@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910060808220.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060808220.3432@localhost.localdomain>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Tue, 06 Oct 2009 08:34:02 -0700
Message-Id: <1254843242.24117.23.camel@dhohndel-mobl.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hohndel@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 08:13 -0700, Linus Torvalds wrote:
> 
> On Tue, 6 Oct 2009, Dirk Hohndel wrote:
> > 
> > I respectfully disagree.
> 
> .. because you don't know what the f*ck you're talking about.

Always a pleasure having an intellectual discourse with you.

> > With the proposed -rc0 there is EXACTLY ONE kernel that is called 2.6.31
> > - the release kernel. And everything else is called something
> > 2.6.xx-rcY.
> 
> No.
> 
> That's simply not _true_.
> 
> Think it through. Deeply. 
> 
> In particular, think about all the developers who start out at known 
> stable points. And they are _supposed_ to start at release points. It 
> means that a lot of versions in the -rc window will NOT have that -rc0 in 
> them.
> 
> In fact, even more commonly (for people who don't rebase, which should be 
> the default), you'll have kernel versions in the merge window (and later) 
> that will have Makefiles that talk about the previous release.
> 
> If you can't get that FUNDAMENTAL FACT, then I don't know what to say.

The fundamental difference in our analysis is that I believe that 1% of
the people using these kernels are developers as you describe above and
99% are people who pull from your tree and build and test.

> > So if you see something that identifies itself as -rc0, you know it's
> > from during the merge window. If you see something that calls itself
> > 2.6.xx then you know it's a release kernel.
> 
> No. No. And NO.

For people simply pulling from your git tree, I think the answer is YES.

> Your kind of magical thinking leads to _problems_. It's literally been a 
> problem that people stop bisecting, because they notice that they start 
> testing kernels that have a version number before the release they already 
> tested as good. Exactly because of your kind of linear thinking.

I think those two things are entirely unrelated. How would calling the
versions in the merge window -merge or -rc0 make any difference
whatsoever in whether people are confused by git bisect behavior?

> We need _less_ linear thinking, not more. And you need to start thinking 
> about other kernels than just my release tree.

I do - I actually track multiple trees and have my own in which I do my
own work.

That still doesn't change my believe that the VAST MAJORITY of the
people out there only track one tree. Yours.

But hey, as you have stated so eloquently, I "don't know what the f*ck
[I'm] talking about", so let's hear what others are thinking.

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center

