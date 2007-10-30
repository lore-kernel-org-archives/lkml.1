Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbXJ3Aro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbXJ3Aro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbXJ3Arg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:47:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35310 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbXJ3Arf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:47:35 -0400
Message-ID: <47267F15.9090302@garzik.org>
Date: Mon, 29 Oct 2007 20:47:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Randy Dunlap <rdunlap@xenotime.net>, hch@infradead.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create instrumentation directory (git repository)
References: <20071029215138.GA4233@Krystal> <20071029154741.cb093f55.rdunlap@xenotime.net> <4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal> <472667F3.3000505@garzik.org> <20071029233515.GA19413@Krystal>
In-Reply-To: <20071029233515.GA19413@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> I see no good reason to have so many different adhoc instrumentation
> mechanisms for profiling (sched, vm, oprofile) and tracing (blktrace,
> suspend/resume tracing) all over the place. Merging them in a single
> directory seems like a good step towards a more generic
> instrumentation/profiling/tracing infrastructure.

Moving files about in directories should be at the /lowest/ end of the 
priority scale.  It makes diffs unreadable, file histories and diffing 
difficult, and a host of other problems.

Please solve the /real/ problems, and then come back and clean up the 
file structure after that is done.  Massive file renaming to satisfying 
some imagined future everything-is-golden scheme is the /last/ step.  It 
is the last step taken because the previous steps inevitably give you 
guidance that you otherwise would not have had at the start of the task.

When I try to diff between old and new alpha oprofile code, I really 
want to know that the reason why diffing is a pain in the ass is more 
than "it seemed like a good first step."


> Back to "profile" and "probes" directory names, they might be short, but
> they do not represent the whole markup-profiling-tracing trio,
> "profile" lacks the tracing part and "probe" lacks the markup part.

You can always add more letters (and words) to even reach the desired 
level of specificity.  That does nothing to help readability though.

Anyway, it should be clear from existing precedent -- existing pathnames 
-- that "instrumentation" is too long, and really IMO too vague anyway.

	Jeff


