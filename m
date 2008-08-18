Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYHRHVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYHRHVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 03:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYHRHU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 03:20:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41587 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYHRHU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 03:20:56 -0400
Date: Mon, 18 Aug 2008 09:20:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Paul Jackson <pj@sgi.com>,
       hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix new warnings in real mode code
Message-ID: <20080818072036.GA30694@elte.hu>
References: <1219043161-19712-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219043161-19712-1-git-send-email-andi@firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> This recent patch
> 
> commit c3965bd15118742d72b4bc1a290d37b3f081eb98
> Author: Paul Jackson <pj@sgi.com>
> Date:   Wed May 14 08:15:34 2008 -0700
> 
>     x86 boot: proper use of ARRAY_SIZE instead of repeated E820MAX constant
> 
> caused these new warnings during a normal build:
> 
> In file included from linux-2.6/arch/x86/boot/memory.c:17:
> linux-2.6/include/linux/log2.h: In function '__ilog2_u32':
> linux-2.6/include/linux/log2.h:34: warning: implicit declaration of function 'fls'

applied to tip/x86/urgent, thanks.

	Ingo
