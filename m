Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZJLGD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZJLGD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZJLGD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:03:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54460 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZJLGD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:03:58 -0400
Date: Mon, 12 Oct 2009 08:03:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [RFC][PATCH 5/9] perf trace: Add Perl scripting support
Message-ID: <20091012060308.GH14995@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <1254809398-8078-6-git-send-email-tzanussi@gmail.com> <20091006130059.GD15320@elte.hu> <1254888565.28917.135.camel@tropicana> <20091007141332.GA21320@infradead.org> <1254974493.6841.17.camel@tropicana> <20091011085846.GF14995@elte.hu> <20091011121630.GC4901@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011121630.GC4901@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > ad-hoc extensions using separate perf-* scripts are fine of course 
> > and i use that myself. But once a facility is part of core perf it 
> > wants to move into the binary. Especially something as central as 
> > scripting support.
> 
> But I think we may want to have some integrated scripts that can play 
> the role of subcommands when it comes to process particular trace 
> events. Because this is just about reading binary traces and put them 
> in a shape that makes sense wrt to the targeted events.

Maybe - and even in those cases we can still embedd those scripts in the 
binary itself (i.e. we can add a mechanism to embedd it as a string and 
execute it from there). It's not like people are going to edit an 
installed script in a bin/ or libexec/ path.

Same goes for any .xml file should we grow a GUI - etc.

	Ingo
