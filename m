Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYHTBht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYHTBht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYHTBhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:37:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43725 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYHTBhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:37:40 -0400
Date: Wed, 20 Aug 2008 03:39:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123 send_IPI_mask_bitmask+0xc3/0xe0()
Message-ID: <20080820013930.GN9807@one.firstfloor.org>
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 09:51:44PM +0200, Vegard Nossum wrote:
> Hi,
> 
> With latest -git (1fca25427482387689fa27594c992a961d98768f), I got
> this on reading from /dev/cpu/*/* while hot-unplugging cpu1.

It's generally known the oprofile doesn't support CPU hotplug well.
Someone needs to make a project out of fixing it properly. Right now
it's just a "don't do that when it hurts"

-Andi

