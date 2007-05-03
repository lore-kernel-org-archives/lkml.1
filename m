Return-Path: <linux-kernel-owner+w=401wt.eu-S1031118AbXECKTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031118AbXECKTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031141AbXECKTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:19:31 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:46653
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031118AbXECKT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:19:29 -0400
Date: Thu, 3 May 2007 03:19:10 -0700
To: Ting Yang <tingy@cs.umass.edu>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070503101910.GB20142@gnuppy.monkey.org>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070502173634.GA11308@in.ibm.com> <20070502174829.GX19966@holomorphy.com> <46395495.3020802@cs.umass.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46395495.3020802@cs.umass.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 11:18:45PM -0400, Ting Yang wrote:
> I just want to point out that ->wait_runtime, in fact, stores the lag of 
> each task in CFS, except that it is also used by other things, and 
> occasionally tweaked (heuristically ?). Under normal cases the sum of 
> lags of all active tasks in such a system, should be a constant 0. The 
> lag information is equally important to EEVDF, when some tasks leave the 
> system (becomes inactive) carrying certain amount of lag. The key point 
> here is that we have to spread the lag (either negative or positive) to 
> all remaining task, so that the fairness of the system is preserved. I 
> thinks CFS implementation does not seems to handle this properly.
> 
> I am running out time today :-( I will write an email about CFS -v8 
> tomorrow, describing 2 issues in CFS I found related to this.

Interesting. I haven't look at the code carefully but that wouldn't
surprise me if this was the case and it led to odd corner cases.

I'm eagerly waiting your analysis and explanation.

bill

