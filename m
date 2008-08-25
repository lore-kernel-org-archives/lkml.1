Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbYHYVYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbYHYVYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYHYVYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:24:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:39298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYHYVYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:24:11 -0400
Date: Mon, 25 Aug 2008 14:24:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123
 send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080825142403.03d7c354@infradead.org>
In-Reply-To: <20080825204700.GB27030@redhat.com>
References: <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com>
	<48B19799.6090703@kernel.org>
	<19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com>
	<19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com>
	<20080824181304.GA5963@redhat.com>
	<20080825183611.GE26610@one.firstfloor.org>
	<20080825185450.GD11894@redhat.com>
	<20080825193926.GF26610@one.firstfloor.org>
	<20080825195029.GA27030@redhat.com>
	<20080825203649.GH26610@one.firstfloor.org>
	<20080825204700.GB27030@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008 16:47:02 -0400
Dave Jones <davej@redhat.com> wrote:

> On Mon, Aug 25, 2008 at 10:36:49PM +0200, Andi Kleen wrote:
>  
>  > > If we get a thermal event that was caused by temporary
>  > > increased workload, temperature will drop off again when that
>  > > workload is complete.
>  > 
>  > But none of the cpufreq governours do this. They only care about
>  > load, not about temperature.
> 
> Which is good enough to stop p4 laptops from shutting down as
> soon as they've finished booting up.\

that's such an enormous gamble it's not funny.


really; if your bios has broken trippoints we should use the kernel
commandline to disable them (and a dmi blacklist if the amount of
bioses that have it wrong is low.. maybe combined with a date based
threshold).

Just praying that p4clockmod keeps it kinda low enough is not the
answer.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
