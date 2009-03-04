Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbZCDWrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbZCDWrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZCDWrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:47:08 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:57894 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbZCDWrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:47:07 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] [RFC] binary reading of ftrace ring buffers
Date: Wed, 4 Mar 2009 23:47:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Martin Bligh <mbligh@google.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
References: <20090304024921.153061228@goodmis.org> <20090304102640.GB31239@elte.hu> <alpine.DEB.2.00.0903040949070.7995@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903040949070.7995@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903042347.16054.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wednesday 04 March 2009, Steven Rostedt wrote:
> On Wed, 4 Mar 2009, Ingo Molnar wrote:
> > Any chance of merging them into a single perl script? I.e. the 
> > perl script would embedd the .c code and build it on every 
> > invocation (into /tmp), so that one can do single-tool tracing 
> > with no immediate binary components. Such self-sufficiency is 
> > very handy when probing systems in a minimally invasive way.
> > 
> > And we could also have twice the ugliness for the same price.
> > 
> 
> Gag, that would really be ugly code ;-)

If you want really ugly code, you could do the SYS_splice in perl
via syscall. Just look it up via "perldoc -f syscall" and play around :-)

Best Regards

Ingo Oeser
