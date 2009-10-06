Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZJFPPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZJFPPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbZJFPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:15:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757395AbZJFPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:15:08 -0400
Date: Tue, 6 Oct 2009 08:13:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dirk Hohndel <hohndel@infradead.org>
cc: Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.01.0910060808220.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>  <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>  <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>  <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <1254839931.24117.9.camel@dhohndel-mobl.amr.corp.intel.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Dirk Hohndel wrote:
> 
> I respectfully disagree.

.. because you don't know what the f*ck you're talking about.

> With the proposed -rc0 there is EXACTLY ONE kernel that is called 2.6.31
> - the release kernel. And everything else is called something
> 2.6.xx-rcY.

No.

That's simply not _true_.

Think it through. Deeply. 

In particular, think about all the developers who start out at known 
stable points. And they are _supposed_ to start at release points. It 
means that a lot of versions in the -rc window will NOT have that -rc0 in 
them.

In fact, even more commonly (for people who don't rebase, which should be 
the default), you'll have kernel versions in the merge window (and later) 
that will have Makefiles that talk about the previous release.

If you can't get that FUNDAMENTAL FACT, then I don't know what to say.

> So if you see something that identifies itself as -rc0, you know it's
> from during the merge window. If you see something that calls itself
> 2.6.xx then you know it's a release kernel.

No. No. And NO.

Your kind of magical thinking leads to _problems_. It's literally been a 
problem that people stop bisecting, because they notice that they start 
testing kernels that have a version number before the release they already 
tested as good. Exactly because of your kind of linear thinking.

We need _less_ linear thinking, not more. And you need to start thinking 
about other kernels than just my release tree.

		Linus
