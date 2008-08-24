Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYHXR7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYHXR7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbYHXR7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:59:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbYHXR7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:59:36 -0400
Message-ID: <48B1A166.1050509@kernel.org>
Date: Sun, 24 Aug 2008 10:59:02 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>	 <20080820013930.GN9807@one.firstfloor.org>	 <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com>	 <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org>	 <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com>	 <48B19799.6090703@kernel.org>	 <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com> <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com>
In-Reply-To: <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> 
> Okay, now I used cpufreq-selector to change to "ondemand" governor,
> and MHz goes back to 3000. Weird. Why would "performance" governor put
> my machine to a constant 375?
> 

That would be a problem... I presume this problem is independent of the 
patch, though?

	-hpa
