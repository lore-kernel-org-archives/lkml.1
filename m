Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZJ2VYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZJ2VYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZJ2VYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:24:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33992 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbZJ2VYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:24:45 -0400
Subject: Re: perf trace errors
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <c62985530910251643k6b3e59c0l6069b08741469b47@mail.gmail.com>
References: <20091011025441.GA18152@lst.de> <20091016083242.GA11174@elte.hu>
	 <20091025071708.GA16936@lst.de>
	 <c62985530910251643k6b3e59c0l6069b08741469b47@mail.gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 29 Oct 2009 17:24:49 -0400
Message-Id: <1256851489.26028.3247.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 00:43 +0100, Frederic Weisbecker wrote:
> 2009/10/25 Christoph Hellwig <hch@lst.de>:
> > On Fri, Oct 16, 2009 at 10:32:42AM +0200, Ingo Molnar wrote:
> >> FYI, these bugs are fixed in latest -tip, your testcase works for me:
> >
> >> Mind checking whether it works for you?
> >
> > Yes, it works on -tip, but not yet on mainline.  What still doesn't
> > work yet on -tip either is printing of dynamic strings in some events,
> > e.g.:
> >
> >       kjournald-1105  [000]   643.002702: block_rq_complete: 253,0 W () 2283224
> 
> 
> Ah, interesting, it means we support __string() but not well other
> dynamic arrays.
> I'll have a look at it.

Frederic,

Have you found anything with this yet? If not, I can take a look too.

-- Steve


