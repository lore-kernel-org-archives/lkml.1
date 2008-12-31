Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYLaIoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYLaIoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYLaIoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:44:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56139 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYLaIop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:44:45 -0500
Date: Wed, 31 Dec 2008 09:44:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] fix compilation error
Message-ID: <20081231084420.GA13665@elte.hu>
References: <1230648007.10677.1.camel@jaswinder.satnam> <20081230205230.GA6151@nowhere> <495AA87D.9060704@kernel.org> <495ABDF8.2070703@kernel.org> <20081231004722.GA28472@nowhere> <495AC45D.8010102@kernel.org> <20081231014747.GB28472@nowhere> <20081231081458.GB12942@elte.hu> <3f9a31f40812310040y27c39b87v456ae38e46031624@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40812310040y27c39b87v456ae38e46031624@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> Hello Ingo,
> 
> On Wed, Dec 31, 2008 at 1:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Could you check whether latest tip/master is still OK? I had these
> > problems resolved locally (but forgot to push them out), and now i also
> > had to do a few conflict resolutions with latest -git, hopefully i have
> > not lost hpa's fixes ...
> >
> 
> With latest/tip, I am still getting error on X86_32 machines :
> 
>   CC      mm/slab.o
> mm/slab.c:105:31: error: tracing/kmemtrace.h: No such file or directory
> make[1]: *** [mm/slab.o] Error 1
> make: *** [mm] Error 2

ok, pushed out a new one - does it build fine now?

	Ingo
