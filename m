Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYHVC1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYHVC1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757686AbYHVC0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:26:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47312 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843AbYHVC0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:26:40 -0400
Date: Fri, 22 Aug 2008 04:28:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Dave Jones <davej@redhat.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123	send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080822022841.GG23334@one.firstfloor.org>
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AE20B8.9000204@kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You may want to see if this patch fixes the problem; it does *NOT* have 
> the correct error behaviour (some of the intervening layers don't 
> propagate errors), but it should make the fault go away.

The alternative would be to just take out those msr_on_cpu() 
interfaces again. Right now they are useless in the kernel,
but still cause problems.

They were only added for OpenVZ's vCPUs which they back then
promised me would hit mainline soon. But that was some time
ago and there wasn't much progress on this.

-Andi

