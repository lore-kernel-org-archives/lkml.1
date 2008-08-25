Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYHYSl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYHYSl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYHYSlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:41:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58369 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbYHYSlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:41:19 -0400
Date: Mon, 25 Aug 2008 14:38:02 -0400
From: Dave Jones <davej@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123
	send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080825183801.GA11894@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	"H. Peter Anvin" <hpa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com> <48B19799.6090703@kernel.org> <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com> <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com> <20080824181304.GA5963@redhat.com> <19f34abd0808251131t511d2d8g925b3dae94620e9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808251131t511d2d8g925b3dae94620e9a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 08:31:04PM +0200, Vegard Nossum wrote:
 
 > Fedora 7 init, which would prompt for the starting of cpuspeed
 > initscript. Turning off echo for the tty was what triggered the
 > slowness; removing cpuspeed from the runlevel entirely solved the
 > problem.
 > 
 > Don't know why cpuspeed would select a governor which runs the CPU at
 > a constant 300 MHz, though.

p4-clockmod is the only cpufreq driver that can run on your hardware.
There's nothing better.   A while back, Fedora stopped loading
(and even building) p4-clockmod, because it sucks so bad.
I can't remember when we made that change, but it sounds like it must
have been a post F7 thing.

	Dave

-- 
http://www.codemonkey.org.uk
