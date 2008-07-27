Return-Path: <linux-kernel-owner+w=401wt.eu-S1757860AbYG0Gfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbYG0Gfk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 02:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYG0Gfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 02:35:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbYG0Gfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 02:35:33 -0400
Date: Sun, 27 Jul 2008 08:35:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] lost sysctl fix
Message-ID: <20080727063521.GA1963@elte.hu>
References: <14615.1217125366@turing-police.cc.vt.edu> <20080726202525.3ac3052f.akpm@linux-foundation.org> <21657.1217130229@turing-police.cc.vt.edu> <20080727040908.GX28946@ZenIV.linux.org.uk> <20080727051702.GY28946@ZenIV.linux.org.uk> <20080727053122.GZ28946@ZenIV.linux.org.uk> <20080727062956.GA24749@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080727062956.GA24749@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > try_attach() should walk into the matching subdirectory, not the first one...
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> > [and yes, that's what that crap had been]
> 
> does this explain the following crash -tip testing just triggered with 
> latest -git:
> 
> [   12.293289] calling  butterfly_init+0x0/0x14
> [   12.298036] BUG: unable to handle kernel NULL pointer dereference at 00000004
> [   12.302065] IP: [<c012c169>] __register_sysctl_paths+0x1af/0x253
> [   12.308058] *pdpt = 0000000000b81001 *pde = 0000000000000000 
> [   12.314809] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC

your patch fixes it.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
