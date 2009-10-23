Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZJWOf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZJWOf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 10:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZJWOf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 10:35:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43345 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZJWOf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 10:35:56 -0400
Date: Fri, 23 Oct 2009 16:35:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       Eric Sandeen <sandeen@redhat.com>
Subject: Re: x86: Remove STACKPROTECTOR_ALL
Message-ID: <20091023143549.GB8305@elte.hu>
References: <20091023073101.3dce4ebb@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023073101.3dce4ebb@infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> 
> >From 87296b9275e3561822e1322f9d9aa6c73424e672 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Fri, 23 Oct 2009 07:27:31 -0700
> Subject: [PATCH] x86: remove STACKPROTECTOR_ALL
> 
> STACKPROTECTOR_ALL has a really high overhead (runtime and stack footprint)
> and is not really worth it protection wise (the normal STACKPROTECTOR is
> in effect for all functions with buffers already), so lets just remove
> the option entirely.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/Kconfig  |    4 ----
>  arch/x86/Makefile |    1 -
>  2 files changed, 0 insertions(+), 5 deletions(-)

Applied, thanks Arjan!

	Ingo
