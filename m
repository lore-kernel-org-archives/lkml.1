Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbZLAQLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbZLAQLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZLAQLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:11:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52092 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbZLAQLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:11:50 -0500
Date: Tue, 1 Dec 2009 17:11:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091201161132.GA24897@elte.hu>
References: <20091130120345.GA18879@linux.vnet.ibm.com>
 <1259582952.20516.209.camel@laptop>
 <20091130123257.GB18879@linux.vnet.ibm.com>
 <1259584907.20516.246.camel@laptop>
 <20091130131928.GC18879@linux.vnet.ibm.com>
 <1259588232.20516.307.camel@laptop>
 <20091130150314.GA10331@redhat.com>
 <20091130151650.GA24316@elte.hu>
 <20091130152910.GB10331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130152910.GB10331@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> On Mon, Nov 30, 2009 at 04:16:50PM +0100, Ingo Molnar wrote:
> > [...]
> > kgdb exists here and today in the kernel and you cannot just build a 
> > facility that doesnt replace it and doesnt integrate well with it.
> 
> Surely you don't mean that: every non-kgdb facility in the kernel 
> meets that definition, even all debugging-related facilities such as 
> perf and ftrace.

Those facilities are not overlapping with kgdb though so my point doesnt 
apply to them. An in-kernel gdb server sure overlaps/extends kgdb 
though.

Btw., perf does meet that definition: it functionally replaces all 
facilities that it overlaps/extends - such as Oprofile. 'What about 
Oprofile?' was one of the first questions asked when we posted perf. 
'What about kgdb?' is the first question to the in-kernel gdb stub 
submission here, for similar reasons.

	Ingo
