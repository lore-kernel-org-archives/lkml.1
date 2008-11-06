Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYKFO25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYKFO25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYKFO2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:28:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36960 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYKFO2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:28:35 -0500
Date: Thu, 6 Nov 2008 15:28:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: align DirectMap in /proc/meminfo
Message-ID: <20081106142815.GC13023@elte.hu>
References: <Pine.LNX.4.64.0811061201090.30226@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811061201090.30226@blonde.site>
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


* Hugh Dickins <hugh@veritas.com> wrote:

> When the split-LRU patches added Inactive(anon) and Inactive(file) lines
> to /proc/meminfo, all counts were moved two columns rightwards to fit in.
> Now move x86's DirectMap lines two columns rightwards to line up.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Being a timid soul, I do wonder if realigning two columns rightwards was
> a reckless breakage of the kernel-userspace API!  but assume that was
> thrashed out at the time, and I've heard of no complaints.

good question - but i have not heard complaints either.

>  arch/x86/mm/pageattr.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

applied to tip/x86/urgent, thanks Hugh!

	Ingo
