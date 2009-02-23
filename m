Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZBWRXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZBWRXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZBWRX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:23:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40315 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZBWRXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:23:25 -0500
Date: Mon, 23 Feb 2009 18:23:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090223172302.GB29344@elte.hu>
References: <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com> <1235304876.4632.10.camel@laptop> <20090222122424.GA9951@redhat.com> <1235387487.4645.28.camel@laptop> <20090223154404.GA30147@redhat.com> <1235406159.4645.366.camel@laptop> <20090223171032.GA2566@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223171032.GA2566@redhat.com>
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


* Frank Ch. Eigler <fche@redhat.com> wrote:

> > Furthermore, trace_mark() exposes that crap like an ABI, now 
> > suppose some distro goes and declares that stable for some 
> > daft reason, imagine the poor sod having to fix something 
> > littered with trace_mark().
> 
> The impression that this is somehow different with tracepoints 
> is mistaken.  Tracepoints are *exactly* as "ABI-like" as 
> markers.

they arent. To the kernel they look like function calls, with no 
ABI properties at all. They can and will change without notice.

	Ingo
