Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYDUMIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYDUMIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYDUMIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:08:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616AbYDUMH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:07:59 -0400
Date: Mon, 21 Apr 2008 14:07:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: unexport kmap_atomic_to_page
Message-ID: <20080421120736.GD6788@elte.hu>
References: <20080421085144.GH26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421085144.GH26897@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the no longer used export of kmap_atomic_to_page.

thanks - i applied all 6 patches of yours to x86.git.

btw:

> ---
> f31eb5842f0a727041ff53355819cac964288428 diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> index 9cf33d3..165c871 100644

would you like this metadata to remain in the commit so that you can 
track it easier? [i guess it's not really necessary as duplicate changes 
are easy to find.]

	Ingo
