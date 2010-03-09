Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0CIPvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 10:51:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:36674 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab0CIPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 10:50:50 -0500
Subject: Re: [PATCH] x86: Add optimized popcnt variants
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
In-Reply-To: <20100309153628.GA2371@aftab>
References: <20100223155852.GF30382@aftab> <4B84118C.90203@zytor.com>
	 <20100223175457.GA2401@aftab> <4B841BC3.1000908@zytor.com>
	 <20100223190614.GB2401@aftab> <4B875BBD.4060104@zytor.com>
	 <20100226074714.GA15310@aftab> <4B88097E.7010608@zytor.com>
	 <20100227082807.GA21706@aftab> <4B8979DA.9000201@zytor.com>
	 <20100309153628.GA2371@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 16:50:40 +0100
Message-ID: <1268149840.5037.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 16:36 +0100, Borislav Petkov wrote:
> > On 02/27/2010 12:28 AM, Borislav Petkov wrote:
> > > Yeah, let's give it another round of testing and queue it for .35 -
> > > AFAIR Ingo runs also a wide testing effort so it spending another cycle
> > > in -tip and being hammered on by us could give us a bit more certainty.
> > > 
> > 
> > Yes, if we can get into -tip then we'll get more test coverage, so I'll
> > queue it up for .35 as soon as the merge window closes.  Please remind
> > me if I forget.
> 
> Hi Peter,
> 
> I see that you've added the HWEIGHT-capitalized interfaces for
> compile-time constants with fce877e3. Which means, the bits in
> <include/asm-generic/bitops/const_hweight.h> from your original patch at
> http://lkml.org/lkml/2010/2/4/119 need changing (or have changed already
> but I've missed them).
> 
> IOW, where can I get the current version of that last patch so that I can
> base my __arch_hweightXX stuff ontop of it for testing?

Should all be fine as it is, that patch
( http://lkml.org/lkml/2010/2/4/119 ) is against a kernel with fce877e3
in, I've just checked and it still applies to tip/master as of this
writing (although it grew a single 2 line offset for 1 hunk).



