Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYHYSeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYHYSeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbYHYSdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:33:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44636 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYHYSdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:33:51 -0400
Date: Mon, 25 Aug 2008 20:36:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080825183611.GE26610@one.firstfloor.org>
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <19f34abd0808240220v77bcdd5di32f8f865b18fc49f@mail.gmail.com> <48B19799.6090703@kernel.org> <19f34abd0808241022j1ab6f3e6qd72b9acba5df4892@mail.gmail.com> <19f34abd0808241045r37eb8661h3cc688b6f0513777@mail.gmail.com> <20080824181304.GA5963@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824181304.GA5963@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Probably because you're using p4-clockmod, and it's crap.

Really should really bite the bullet and just remove it. People 
run in this all the time and I bet you can count the people who
actually use it consciously and usefully with one hand.

Or at least only make it run when the user set a "I_REALLY_KNOW_WHAT_I_AM_DOING"
option explicitely.

-Andi
