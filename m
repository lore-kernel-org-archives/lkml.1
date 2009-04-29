Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZD2KhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZD2KhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbZD2KhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:37:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56397 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZD2KhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:37:04 -0400
Date: Wed, 29 Apr 2009 12:36:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] tracing/filters: distinguish between signed and
	unsigned fields
Message-ID: <20090429103655.GD2373@elte.hu>
References: <1240905893.6416.120.camel@tropicana> <20090428234645.c1780736.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428234645.c1780736.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 28 Apr 2009 03:04:53 -0500 Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > +#define is_signed(t)	(((t)-1) < 0)
> 
> geeze that was confusing until I worked out that `t' is supposed to be
> the name of a C type.

good point, i've changed its name to is_signed_type().

> 	is_signed(0) == true!
> 
> whee.

I also added parantheses around the -1 literal to make it clear that 
this is a cast.

> Rename it to is_signed_type() or something, please?

done.

Thanks,

	Ingo
