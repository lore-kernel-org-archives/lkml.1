Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYHYTRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYHYTRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbYHYTQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:16:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40171 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562AbYHYTQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:16:55 -0400
Date: Mon, 25 Aug 2008 15:13:37 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123
	send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080825191337.GA25082@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com> <48B19799.6090703@kernel.org> <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com> <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com> <20080824181304.GA5963@redhat.com> <20080825183611.GE26610@one.firstfloor.org> <48B30327.5080705@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B30327.5080705@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 12:08:23PM -0700, H. Peter Anvin wrote:
 > Andi Kleen wrote:
 > >> Probably because you're using p4-clockmod, and it's crap.
 > > 
 > > Really should really bite the bullet and just remove it. People 
 > > run in this all the time and I bet you can count the people who
 > > actually use it consciously and usefully with one hand.
 > > 
 > > Or at least only make it run when the user set a "I_REALLY_KNOW_WHAT_I_AM_DOING"
 > > option explicitely.
 > 
 > CONFIG_BROKEN?

It's not really broken (at least in the CONFIG_BROKEN sense), it just sucks
when used in the wrong situations. (Which is 99% of the use-cases people
try to use it).

	Dave

-- 
http://www.codemonkey.org.uk
