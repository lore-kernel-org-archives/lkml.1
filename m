Return-Path: <linux-kernel-owner+w=401wt.eu-S1754474AbYIFRCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbYIFRCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYIFRB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:01:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57413 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYIFRB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:01:59 -0400
Date: Sat, 6 Sep 2008 19:01:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH -next] x86: make setup_xstate_init() __init
Message-ID: <20080906170142.GF4856@elte.hu>
References: <20080830020334.GA22978@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830020334.GA22978@x200.localdomain>
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


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> WARNING: vmlinux.o(.text+0x22453): Section mismatch in reference from the function setup_xstate_init() to the function .init.text:__alloc_bootmem()
> The function setup_xstate_init() references the function __init __alloc_bootmem().
> This is often because setup_xstate_init lacks a __init annotation or the annotation of __alloc_bootmem is wrong.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  arch/x86/kernel/xsave.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to tip/x86/xsave, thanks Alexey.

	Ingo
