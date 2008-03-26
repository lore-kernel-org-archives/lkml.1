Return-Path: <linux-kernel-owner+w=401wt.eu-S1756809AbYCZH1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbYCZH1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 03:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbYCZH1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 03:27:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34808 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbYCZH1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 03:27:32 -0400
Date: Wed, 26 Mar 2008 08:27:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify sync_test_bit()
Message-ID: <20080326072714.GB3442@elte.hu>
References: <47DA3DC0.76E4.0078.0@novell.com> <20080321111826.GC20420@elte.hu> <47E56BBA.2000803@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E56BBA.2000803@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3483]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Subject: x86: use macro parameters on sync_test_bit
>
> Using a naked parameterless macro could lead to other tokens being 
> unexpectedly replaced.

> -#define sync_test_bit test_bit
> +#define sync_test_bit(nr, addr) test_bit(nr, addr)

thanks Jeremy, applied.

	Ingo
