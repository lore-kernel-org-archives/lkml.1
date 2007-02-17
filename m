Return-Path: <linux-kernel-owner+w=401wt.eu-S1946733AbXBQNvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946733AbXBQNvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 08:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946739AbXBQNvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 08:51:16 -0500
Received: from colin.muc.de ([193.149.48.1]:1427 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946733AbXBQNvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 08:51:15 -0500
Date: 17 Feb 2007 14:51:13 +0100
Date: Sat, 17 Feb 2007 14:51:12 +0100
From: Andi Kleen <ak@muc.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Zachary Amsden <zach@vmware.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for paravirt_ops interface
Message-ID: <20070217135112.GA15102@muc.de>
References: <20070216022449.739760547@goop.org> <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com> <45D61C74.2000601@vmware.com> <Pine.LNX.4.64.0702161312460.28871@schroedinger.engr.sgi.com> <45D626BB.20007@vmware.com> <Pine.LNX.4.64.0702161356380.29218@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702161356380.29218@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 01:59:44PM -0800, Christoph Lameter wrote:
> On Fri, 16 Feb 2007, Zachary Amsden wrote:
> 
> > Yes, but that is just because the Xen hooks happens to be near the last part
> > of the merge.  VMI required some special hooks, as do both Xen and lhype (I
> > think ... Rusty can correct me if lhype's puppy's have precluded the addition
> > of new hooks).  Xen page table handling is very different, mostly it is trap
> > and emulate so writable page tables can work, which means they don't always
> > issue hypercalls for PTE updates, although they do have that option, should
> > the hypervisor MMU model change, or performance concerns prompt a different
> > model (or perhaps, migration?)
> 
> Well looks like there are still some major design issues to be ironed out. 
> What is proposed here is to make paravirt_ops a fake generic 
> API and then tunnel through it to vendor specific kernel mods.

That was always its intention. It's not a direct interface to a hypervisor,
but an somewhat abstracted interface to a "hypervisor driver" 

But you're right that there are currently still quite a lot of hooks
being added. I plan to be much more strict on that in the future.

-Andi
