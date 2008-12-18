Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752839AbYLRT6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYLRT6T (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYLRT6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:58:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56710 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbYLRT6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:58:05 -0500
Date: Thu, 18 Dec 2008 20:57:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: revert CONFIG_RELOCATABLE=y defconfig change
Message-ID: <20081218195755.GA10786@elte.hu>
References: <20081218173506.GA29781@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081218173506.GA29781@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> >From 37a92bc970ce025d8a42fed27413485fd341db31 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Thu, 18 Dec 2008 18:03:20 +0100
> Subject: [PATCH] x86: revert CONFIG_RELOCATABLE=y defconfig change
> 
> This commit:
> 
> commit 5cb04df8d3f03e37a19f2502591a84156be71772
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Sun May 4 19:49:04 2008 +0200
> 
>    x86: defconfig updates
> 
> changed CONFIG_RELOCATABLE from n to y, which may lead to a mismatch
> between the vmlinux debug information and the runtime location of the
> kernel, even when the bootloader does not relocate the kernel.
> 
> Revert the specific change. Works for me with GRUB and qemu.
> 
> Reference: http://lkml.org/lkml/2008/11/25/243
> 
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  arch/x86/configs/i386_defconfig   |    2 +-
>  arch/x86/configs/x86_64_defconfig |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

applied to tip/x86/defconfig, thanks Vegard!

	Ingo
