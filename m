Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753782AbYLRMhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbYLRMhX (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 07:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYLRMhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 07:37:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46612 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbYLRMg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 07:36:59 -0500
Date: Thu, 18 Dec 2008 13:36:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86: tls.c declare sys_set_thread_area and
	sys_get_thread_area before they get used
Message-ID: <20081218123653.GG25715@elte.hu>
References: <1229536132.23068.4.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229536132.23068.4.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Impact: cleanup
> 
> In asm/syscalls.h moved out sys_set_thread_area and sys_get_thread_area as it is common for both 32 and 64 bit.
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/include/asm/syscalls.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)

applied	to tip/x86/cleanups, thanks Jaswinder!

	Ingo
