Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbZBTBNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbZBTBNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 20:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbZBTBNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 20:13:42 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57325 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZBTBNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 20:13:41 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] Add tracepoints to track pagecache transition
Cc: kosaki.motohiro@jp.fujitsu.com, Atsushi Tsuji <a-tsuji@bk.jp.nec.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Kazuto Miyoshi <miyoshi@linux.bs1.fc.nec.co.jp>, rostedt@goodmis.org,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>
In-Reply-To: <1235053291.8424.14.camel@lts-notebook>
References: <2f11576a0902190512y1ac60b11s4927533977dc01e7@mail.gmail.com> <1235053291.8424.14.camel@lts-notebook>
Message-Id: <20090220093813.43EF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 20 Feb 2009 10:13:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > Currently, we can understand the amount of pagecache from "Cached"
> > > in /proc/meminfo. So I'd like to understand which files are using pagecache.
> > 
> > There is one meta question, Why do you think file-by-file pagecache
> > infomartion is valueable?
> 
> One might take a look at Marcello Tosatti's old 'vmtrace' patch.  It
> contains it's own data store/transport via relayfs, but the trace points
> could be ported to the current kernel tracing infrastructure.
> 
> Here's a starting point:   http://linux-mm.org/VmTrace
> 
> Quoting from that page:
> 
> >From the previous email to linux-mm:
> >"The sequence of pages which a given process or workload accesses
> >during its lifetime, a.k.a. "reference trace", is very important
> >information. It has been used in the past for comparison of page
> >replacement algorithms and other optimizations..."

Sure.
but strong difference exist.

vmtrace
  - can run standalone
  - reviewer can confirm its output result is useful or not.

Christoph also explained reason more kindly.
I think we need useful consumer. 


