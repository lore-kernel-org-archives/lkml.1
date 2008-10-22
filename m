Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbYJVLgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbYJVLgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYJVLgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:36:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54777 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbYJVLgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:36:32 -0400
Date: Wed, 22 Oct 2008 13:36:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] kernel/resource: Fix reserve_region_with_split()
	section mismatch.
Message-ID: <20081022113622.GB4583@elte.hu>
References: <20081022103111.GA14013@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022103111.GA14013@linux-sh.org>
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


* Paul Mundt <lethal@linux-sh.org> wrote:

> reserve_region_with_split() calls in to __reserve_region_with_split(), 
> which is an __init function. [...]

applied to tip/core/urgent, thanks Paul!

> [...] All callers of reserve_region_with_split() are also __init 
> functions, so make it __init too.

... there's a single caller of that function ;-)

	Ingo
