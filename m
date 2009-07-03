Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZGCKjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZGCKjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZGCKjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:39:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55464 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZGCKjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:39:43 -0400
Date: Fri, 3 Jul 2009 12:38:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Robert Richter <robert.richter@amd.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Anton Blanchard <anton@samba.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Peter Zijlstra <peterz@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf tools: gitignore *.data
Message-ID: <20090703103852.GA3242@elte.hu>
References: <1246603147.2322.3.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246603147.2322.3.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.5
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> perf.data made by perf record is a data file and need to be 
> ignored by git
> 
> Added *.data so that perf.data and its friends will be ignored.

>  cscope*
> +*.data

ok, this is something i wanted to revisit eventually - the 
'perf.data' name sucks a bit - as .data postfix is quite unspecific.

Perhaps trace.perf is a better default name, and all files would 
have the .perf postfix?

I've Cc:-ed a number of folks who might have an opinion about this - 
what would be the best default naming and postfix for perf binary 
files?

	Ingo
