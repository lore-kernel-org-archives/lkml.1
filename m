Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbXIYAJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbXIYAJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXIYAJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:09:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:49869 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbXIYAJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:09:49 -0400
Subject: Re: x86_64: potential critical issue with quicklists and page
	table pages
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, asit.k.mallick@intel.com
In-Reply-To: <Pine.LNX.4.64.0709241438220.31469@schroedinger.engr.sgi.com>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
	 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.999.0709211153060.16478@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0709211204050.16478@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0709211205570.17160@schroedinger.engr.sgi.com>
	 <alpine.LFD.0.999.0709211212130.16478@woody.linux-foundation.org>
	 <1190669265.6886.69.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0709241438220.31469@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 10:09:28 +1000
Message-Id: <1190678969.12382.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-24 at 14:42 -0700, Christoph Lameter wrote:
> On Tue, 25 Sep 2007, Benjamin Herrenschmidt wrote:
> 
> > I'd suggest just reverting the patch for now (well, I see from the
> > commit list that you did just that) and I'll try to come up with
> > something better.
> 
> That would be great. Note that the reversal of the x86_64 quicklist 
> support patch does not address the issue that is (as pointed out by 
> Siddha) in core code and not in x86_64 arch dode. The fix that I posted 
> fixes the core issue.
> 
> > Christoph, I'd be happy if you didn't start butchering mmu_gather just
> > right now since I'm doing just that and it will collide all over the
> > place :-) Or if you want something specific done, please throw
> > ideas/patches at me and I'll integrate that in my serie.
> 
> Any "butchering" was done for 2.6.22. 2.6.23 only added arch support for 
> x86_64 since Andi forgot to merge it for .22. I'd be glad if you could 
> look into this and make quicklists interoperate nicely withh mmu gather.

I'll try, I'll let you know. Give me a few days to finish catching up
with backlog of things before i get back to it though.

Cheers,
Ben.


