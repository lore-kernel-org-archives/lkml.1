Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbYLDKHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbYLDKHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYLDKGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:06:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYLDKGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:06:50 -0500
Date: Thu, 4 Dec 2008 11:06:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Korty <joe.korty@ccur.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: Change thread_info's flag field back to 32 bits
Message-ID: <20081204100620.GA17634@elte.hu>
References: <20081203235819.GA17615@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203235819.GA17615@tsunami.ccur.com>
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


* Joe Korty <joe.korty@ccur.com> wrote:

> Change x86_64's thread_info 'flags' field back to __u32.
> 
> This was changed to 'unsigned long' when the thread_info*.h
> for i386 and x86_64 were merged.  Change it back.  We can
> do this as only 27 bits of 'flags' are actually used.
> 
> This change actually packs down thread_info by 64 bits:
> 32 bits are saved by the smaller flags, and 32 bits are
> saved by the following 'mm_segment_t field' becoming
> naturally 64-bit aligned.
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>

applied, thanks Joe!

	Ingo
