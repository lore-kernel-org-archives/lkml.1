Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbZKNAOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbZKNAOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 19:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZKNAOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 19:14:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53773 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbZKNAOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 19:14:08 -0500
Date: Sat, 14 Nov 2009 01:14:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 2/3] Add coredump tracepoint
Message-ID: <20091114001410.GC24738@elte.hu>
References: <20091113225226.15079.90813.stgit@harusame>
 <20091113225233.15079.41600.stgit@harusame>
 <20091113233912.192A3100E@magilla.sf.frob.com>
 <20091114000234.GA24738@elte.hu>
 <20091114000627.48ED615E8@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091114000627.48ED615E8@magilla.sf.frob.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > Do you know about exact usecases where these tracepoints would be 
> > utilized? Would be interesting (and relevant) to list them.
> 
> Masami's colleagues do have something in particular in mind, but I'm 
> not sure whether they intend to use systemtap as part of the 
> implementation of that or not.

Some sort of flexible core dump server perhaps, driven by user-space 
logic? (vastly more flexible than coredump-filter or coredump ulimits 
are today)

	Ingo
