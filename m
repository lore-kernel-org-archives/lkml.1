Return-Path: <linux-kernel-owner+w=401wt.eu-S933727AbZHEHaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbZHEHaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933705AbZHEHaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:30:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36920 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685AbZHEHaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:30:14 -0400
Date: Wed, 5 Aug 2009 09:29:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ftrace scripts and make V=1
Message-ID: <20090805072952.GC19322@elte.hu>
References: <21d7e9970908050023j2807ef3bi1321ac2a1fd9a743@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970908050023j2807ef3bi1321ac2a1fd9a743@mail.gmail.com>
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


* Dave Airlie <airlied@gmail.com> wrote:

> Hey,
> 
> So I spent 3-4 hrs today (I'm stupid yes) tracking down a .o 
> breakage by blaming rawhide gcc/binutils as I was using make 
> V=1and seeing only the compiler chain running,

Hm, is this that powerpc related build bug you just reported?

> However some ftrace script was sneaking in afterwards and screwing 
> up the .o without mentioning itself.
> 
> Surely V=1 should print all these shitty scripts its running?

Definitely, and it should print non-shitty scripts too,
just in case ;-)

	Ingo
