Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZGJDxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZGJDxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZGJDxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:53:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51828 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbZGJDxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:53:34 -0400
Date: Fri, 10 Jul 2009 05:53:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH 0/2] perf_counter: add tracepoint support
Message-ID: <20090710035319.GA5077@elte.hu>
References: <cover.1246912068.git.jbaron@redhat.com> <20090709031032.GA6412@nowhere> <1247126283.9777.318.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247126283.9777.318.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Thu, 2009-07-09 at 05:10 +0200, Frederic Weisbecker wrote:

> > (RFD parenthesis: why not using the one in kernel/trace for all 
> > perf events? Now that it is lockless, it would fit nicely 
> > inside: no fear about NMI context).
> 
> because that one doesn't have a single-buffer mode you can mmap().

Yeah, the ring-buffer code could certainly be abstracted out better 
to allow this. Once that is done it would allow us to do a couple of 
nice things: such as splice support (which could perhaps be faster 
than mmap for perf record) and the sampling of tracepoints would 
become a whole lot easier a well. But it's certainly not a trivial 
job!

	Ingo
