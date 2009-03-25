Return-Path: <linux-kernel-owner+w=401wt.eu-S1763617AbZCYSS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763617AbZCYSS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 14:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbZCYSSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 14:18:50 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:44980 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214AbZCYSSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 14:18:49 -0400
Subject: Re: [PATCH -tip] x86: move vmware to hypervisor
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1238002693.2500.52.camel@ht.satnam>
References: <1237281581.7907.2.camel@ht.satnam>
	 <20090317093919.GD6477@elte.hu> <1237283318.7907.9.camel@ht.satnam>
	 <49BFC6CB.9070603@zytor.com>
	 <1237958994.5556.5.camel@localhost.localdomain>
	 <20090325125955.GB516@elte.hu>  <1237999971.32497.12.camel@alok-dev1>
	 <1238000840.2500.49.camel@ht.satnam>  <1238001853.32497.22.camel@alok-dev1>
	 <1238002693.2500.52.camel@ht.satnam>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 25 Mar 2009 11:18:47 -0700
Message-Id: <1238005127.32497.38.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 10:38 -0700, Jaswinder Singh Rajput wrote:
> On Wed, 2009-03-25 at 10:24 -0700, Alok Kataria wrote:
> > On Wed, 2009-03-25 at 10:07 -0700, Jaswinder Singh Rajput wrote:
> > > On Wed, 2009-03-25 at 09:52 -0700, Alok Kataria wrote:
> > > > > 
> > > > > vmware can be considered a CPU here, so i think making the disabling 
> > > > > also depend on PROCESSOR_SELECT.
> > > > 
> > > > Ingo, this code is not just to be used by VMware, the reason we did this
> > > > generically was so that a guest could run unaltered on *any* fully
> > > > virtualized hypervisor.
> > > > And give that this code is just a boot setup thing, the only thing this
> > > > patch saves over here is not running the detection code on native
> > > > systems. All the rest of the code is guarded by the
> > > > "boot_cpu_data.x86_hyper_vendor" checks anyways.  
> > > > 
> > > > I don't really see the point of adding one more config option just for
> > > > this. 
> > > > 
> > > 
> > > Can you please explain what is the point of adding this support all the
> > > time if this is useless for 99.9% of cases. IMHO, it should be optional.
> > 
> > First of all, I don't know how did you get to the 99.9% number, though I
> > think its not a point worth debating, just like to share some info with
> > you. More and more people are adopting virtualization now a days and
> > give the trend i don't see just 0.1% people running Linux on virtualized
> > hardware. So though its not a common case there is still a large user
> > base. 
> 
> I am agree with you there is no point for debate.
> 
> If someone need this option, she can enable it and use it.


You seem to be missing the point I raised in the previous mail. Its
below for your reference.

> I am not saying we should not hide this behind a config at all. The
> point is there is nothing that we save by adding a new config, so what's
> the point at all. If you can give me a solid reason like, say, you save
> 1% code space with this config option, or 'n' sec in the boottime,  I am
> all ears for such an argument.
> 
> 

So, if there are any tangible benefits with doing this I am ok with it,
but your current argument about "Freedom to user"  doesn't sound too
compelling. 

--
Alok

