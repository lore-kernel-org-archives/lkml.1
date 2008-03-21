Return-Path: <linux-kernel-owner+w=401wt.eu-S1757166AbYCULh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbYCULh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 07:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYCULht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 07:37:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42580 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYCULhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 07:37:48 -0400
Date: Fri, 21 Mar 2008 12:37:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: traps_32.c - use KSYM_NAME_LEN instead of numeric
	value
Message-ID: <20080321113737.GI20420@elte.hu>
References: <20080315083426.GA8086@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080315083426.GA8086@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> It's safer to use KSYM_NAME_LEN instead of numeric constant because we 
> could get buffer overrun someday if KSYM_NAME_LEN would be changed to 
> a bigger value.

thanks, applied.

	Ingo
