Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbYHYTJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbYHYTJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYHYTJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:09:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbYHYTJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:09:06 -0400
Message-ID: <48B30327.5080705@kernel.org>
Date: Mon, 25 Aug 2008 12:08:23 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dave Jones <davej@redhat.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com> <48B19799.6090703@kernel.org> <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com> <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com> <20080824181304.GA5963@redhat.com> <20080825183611.GE26610@one.firstfloor.org>
In-Reply-To: <20080825183611.GE26610@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Probably because you're using p4-clockmod, and it's crap.
> 
> Really should really bite the bullet and just remove it. People 
> run in this all the time and I bet you can count the people who
> actually use it consciously and usefully with one hand.
> 
> Or at least only make it run when the user set a "I_REALLY_KNOW_WHAT_I_AM_DOING"
> option explicitely.
> 

CONFIG_BROKEN?

	-hpa
