Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYK0Lud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYK0Lud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 06:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYK0LuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 06:50:22 -0500
Received: from www.tglx.de ([62.245.132.106]:40679 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYK0LuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 06:50:22 -0500
Date: Thu, 27 Nov 2008 12:49:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Miller <davem@davemloft.net>
cc: eranian@gmail.com, eranian@googlemail.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <20081127.034247.72331360.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.0811271246200.3325@localhost.localdomain>
References: <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com> <20081127113115.GH6703@one.firstfloor.org> <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com> <20081127.034247.72331360.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, David Miller wrote:

> From: "stephane eranian" <eranian@googlemail.com>
> Date: Thu, 27 Nov 2008 12:35:54 +0100
> 
> > I am still wondering how Oprofile handles the case where multiple
> > processes or threads access the same file descriptor.
> 
> There's only one profiling buffer active on a given cpu,
> so it's pure per-cpu value insertion.
> 
> In any event I think that NMI profiling is a must, especially
> for the kernel.  You get total unusable crap otherwise.  I
> just learned this the hard way having gotten an NMI'ish scheme
> working on sparc64 just the other day.

Not arguing about that, I'm just not agreeing with the implementation.

So for the moment we can go w/o the NMI and implement it cleanly after
we got the initial lot in.

Thanks,

	tglx

