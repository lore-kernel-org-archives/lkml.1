Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYK0M1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYK0M1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYK0M1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:27:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46785 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYK0M1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:27:40 -0500
Date: Thu, 27 Nov 2008 13:38:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>, eranian@gmail.com,
       eranian@googlemail.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127123811.GJ6703@one.firstfloor.org>
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com> <20081127113115.GH6703@one.firstfloor.org> <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com> <20081127.034247.72331360.davem@davemloft.net> <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2008 at 12:49:37PM +0100, Thomas Gleixner wrote:
> On Thu, 27 Nov 2008, David Miller wrote:
> 
> > From: "stephane eranian" <eranian@googlemail.com>
> > Date: Thu, 27 Nov 2008 12:35:54 +0100
> > 
> > > I am still wondering how Oprofile handles the case where multiple
> > > processes or threads access the same file descriptor.
> > 
> > There's only one profiling buffer active on a given cpu,
> > so it's pure per-cpu value insertion.
> > 
> > In any event I think that NMI profiling is a must, especially
> > for the kernel.  You get total unusable crap otherwise.  I
> > just learned this the hard way having gotten an NMI'ish scheme
> > working on sparc64 just the other day.
> 
> Not arguing about that, I'm just not agreeing with the implementation.
> 
> So for the moment we can go w/o the NMI and implement it cleanly after
> we got the initial lot in.

Note once Stephane readds PEBS support (it is currently stripped out)
you'll be also able to get somewhat reasonable results at least on modern
Intel x86 without NMI profiling. But longer term it is still
very useful because PEBS has some drawbacks too

-Andi
-- 
ak@linux.intel.com
