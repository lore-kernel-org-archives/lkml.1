Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZGCMlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZGCMlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 08:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZGCMlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 08:41:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbZGCMlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 08:41:06 -0400
Date: Fri, 3 Jul 2009 14:40:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       paulus@samba.org, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: atomic64_t: _cmpxchg() & _read() optimizations
Message-ID: <20090703124047.GD7161@elte.hu>
References: <20090701144913.GA28172@elte.hu> <20090701164700.29780.15103.stgit@warthog.procyon.org.uk> <alpine.LFD.2.01.0907011004000.3605@localhost.localdomain> <4A4D2239.5000602@gmail.com> <alpine.LFD.2.01.0907021419560.3210@localhost.localdomain> <20090703120159.GB7161@elte.hu> <4A4DF8F9.9030503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4DF8F9.9030503@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Seems cool, I am going to apply it and test it too.
> 
> I cooked following patch, to address _cmpxchg() and _read().

ok, lemme push out the series, i already picked up many of your 
suggestions. You should get them as tip-bot commit notifications in 
this discussion, threaded around a single mail, with you Cc:-ed.

	Ingo
