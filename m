Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZCRQov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZCRQov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:44:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZCRQol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:44:41 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56245 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbZCRQol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:44:41 -0400
Date: Wed, 18 Mar 2009 17:44:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: William Cohen <wcohen@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Documenting kernel tracepoints
Message-ID: <20090318164433.GA31315@elte.hu>
References: <49C122DF.7020803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C122DF.7020803@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* William Cohen <wcohen@redhat.com> wrote:

> There are a number of tracepoints in the latest kernels, but not 
> much documentation on the tracepoints.  If a very recent version 
> of systemtap is available on the system, a list of the probe 
> points can be obtained with:
> 
> stap -p2 -e 'probe kernel.trace("*") {exit()}'|sort
> 
> However, this only provides the names. It doesn't provide 
> information about what information the probe point provides or the 
> arguments available at the probe point.
> 
> Currently, a number of kernel functions and structures are 
> documented with embedded comments that are extracted with 
> kernel-doc. Seems like it would be reasonable to extend this to 
> support tracepoints. Any thoughts or comments about this approach?

FYI, in the latest tracing tree (targeted for 2.6.30) all 
tracepoints show up under /debug/tracing/events/.

	Ingo
