Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbYJVOym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbYJVOym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYJVOyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:54:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46328 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382AbYJVOyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:54:33 -0400
Date: Wed, 22 Oct 2008 16:54:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Petr Tesarik <ptesarik@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 syscall.h: fix argument order
Message-ID: <20081022145403.GB23060@elte.hu>
References: <1223913511.15996.13.camel@elijah.suse.cz> <20081014014004.B637F154284@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081014014004.B637F154284@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> Petr Tesarik noticed that I'd bungled the syscall_get_arguments code for
> 64-bit kernels, so it inverted the order of the syscall argument registers.
> Petr wrote a patch to fix that, and I've amended it to fix the same braino
> in the syscall_set_arguments code.
> 
> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  include/asm-x86/syscall.h |  106 +++++++++++++++++++++++----------------------
>  1 files changed, 54 insertions(+), 52 deletions(-)

applied to tip/x86/urgent, thanks! I added an:

  Original-by: Petr Tesarik <ptesarik@suse.cz>

because Petr's SOB on the first line looks weird.

	Ingo
