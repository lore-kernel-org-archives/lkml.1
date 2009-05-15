Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbZEORhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbZEORhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 13:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZEORh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:37:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34754 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329AbZEORh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:37:29 -0400
Date: Fri, 15 May 2009 19:37:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Introduce "struct wait_info" to simplify
	wait_task*() pathes
Message-ID: <20090515173720.GB29647@elte.hu>
References: <1242216490-8226-1-git-send-email-v.mayatskih@gmail.com> <1242216490-8226-2-git-send-email-v.mayatskih@gmail.com> <87tz3ozuuw.wl%vmayatsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tz3ozuuw.wl%vmayatsk@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Vitaly Mayatskikh <v.mayatskih@gmail.com> wrote:

> At Wed, 13 May 2009 11:13:58 -0700 (PDT), Roland McGrath wrote:
> 
> > What's the benefit of this?  Those parameters are probably 
> > happily in registers and compiled well, I would guess.  Adding 
> > more memory copying does not seem like a benefit.  Have you 
> > verified that your change reduces code size or something like 
> > that?
> 
> Yeah, I was wrong. There's no benefit in size of .text

but there's a lot of benefit in cleanliness - just look at the 
simplification of the prototypes.

	Ingo
