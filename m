Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbYFTOhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbYFTOhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbYFTOhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:37:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55631 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbYFTOhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:37:34 -0400
Date: Fri, 20 Jun 2008 16:37:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Unify crashkernel reservation for 32 and 64 bit
Message-ID: <20080620143717.GH8135@elte.hu>
References: <1213969102-17400-1-git-send-email-bwalle@suse.de> <20080620135645.GD8135@elte.hu> <20080620160223.4a0f1dd8@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620160223.4a0f1dd8@halley.suse.de>
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


* Bernhard Walle <bwalle@suse.de> wrote:

> > famous last words :)
> > 
> > can you see any functionality difference between them? If yes, that 
> > should be declared.
> 
> The only difference was the calculation of memory -- it's more 
> complicated on i386 because of high memory support, so that was 
> outsourced to an inline function. However, because the highmem is in
> 
>   #ifdef CONFIG_HIGHMEM
>   #endif
> 
> and CONFIG_HIGHMEM is off on x86-64, that doesn't matter. Do you see 
> another issue?

i can see no issue, i was just was confused a bit by the "more or less" 
qualifier.

I've applied your patch to tip/x86/mpparse, thanks Bernhard.

> I tested it on both x86-64 and i386, with CONFIG_KEXEC on and off (so 
> that it compiles).

that's always good to know - it's useful to know the amount and scope of 
testing - i've put this into the changelog.

	Ingo
