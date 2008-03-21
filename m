Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYCULh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYCULh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbYCULhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:37:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42515 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbYCULhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:37:16 -0400
Date: Fri, 21 Mar 2008 12:37:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: parocessor.h - use PAGE_SIZE instead of numeric
	value v2
Message-ID: <20080321113700.GH20420@elte.hu>
References: <20080313164456.GA7560@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313164456.GA7560@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1383]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> This patch replaces numeric constant with an appropriate macro
> 
> Also 0x800000000000UL is changed to bit shifting which is complement 
> to the code comment (thanks hpa for notice)

> -#define TASK_SIZE64	(0x800000000000UL - 4096)
> +#define TASK_SIZE64	((1UL << 47) - PAGE_SIZE)

thanks Cyrill, applied.

	Ingo
