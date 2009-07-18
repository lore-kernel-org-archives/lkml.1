Return-Path: <linux-kernel-owner+w=401wt.eu-S1751087AbZGRL5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087AbZGRL5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 07:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbZGRL5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 07:57:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbZGRL5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 07:57:07 -0400
Date: Sat, 18 Jul 2009 13:55:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-ext4@vger.kernel.org
Subject: Re: ext4 memory leak (was Re: [PATCH] x86: _edata should include
	all .data.* sections on X86_64)
Message-ID: <20090718115556.GA31007@elte.hu>
References: <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com> <4A5C41C8.7040904@fisher-privat.net> <1247564356.28240.30.camel@pc1117.cambridge.arm.com> <1247565175.28240.37.camel@pc1117.cambridge.arm.com> <4A5C5A59.5080304@fisher-privat.net> <1247567499.28240.48.camel@pc1117.cambridge.arm.com> <4A5C5FD0.3020204@fisher-privat.net> <1247574390.28240.67.camel@pc1117.cambridge.arm.com> <20090715080336.GA4823@skywalker> <4A5D9939.3000500@fisher-privat.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5D9939.3000500@fisher-privat.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Alexey Fisher <bug-track@fisher-privat.net> wrote:

> This patch work for me.

nice. Any leftovers that might be false positives and need 
annotation?

We learned this with lockdep: the moment a typical x86 distro bootup 
is 'warnings free', utility of the debugging facility increases 
dramatically: people can standardize on 'kmemleak should never 
produce warnings' workflows and distros can also start feeding 
kmemleak reports into kerneloops.org or so.

So the general direction kmemleak is moving into is really 
encouraging.

	Ingo
