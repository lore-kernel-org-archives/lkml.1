Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbZE0XOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbZE0XOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZE0XOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:14:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58827 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbZE0XOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:14:45 -0400
Date: Thu, 28 May 2009 01:14:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Don't convert function's local variable name
	in macro
Message-ID: <20090527231435.GC20509@elte.hu>
References: <4A1D41C2.2010903@cn.fujitsu.com> <20090527230505.GG5982@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527230505.GG5982@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Wed, May 27, 2009 at 09:36:02PM +0800, Zhaolei wrote:
> > "call" is a argument of macro, but it is also used as a local variable name of
> > function in macro.
> > We should keep this local variable name static although it haven't cause
> > problem now.
> > 
> > [ Impact: cleanup, no functionality changed ]
> 
> 
> I'm applying it.
> 
> Note, I'm also changing the impact line. This is more than a
> cleanup, it's a real fix to prevent from possible CPP side effects.
> 
> So I'll put instead:
> 
> [ Impact: prevent from accidental CPP substitution ]

I suspect it should be something like:

  [ Impact: robustify macro ]

or so.

	Ingo
