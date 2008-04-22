Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbYDVNeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbYDVNeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbYDVNeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:34:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55621 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbYDVNeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:34:08 -0400
Date: Tue, 22 Apr 2008 15:33:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       Peter Zijlstra <peterz@infradead.org>,
       Soeren Sandmann Pedersen <sandmann@redhat.com>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH 0/3] ftrace: overrun accounting and trace_pipe headers
Message-ID: <20080422133344.GE7311@elte.hu>
References: <20080421210935.460817943@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421210935.460817943@goodmis.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> The first patch in this series adds accounting to record overruns. 
> That is where the writing catches up to the reading of the buffer. 
> This really only matters for trace_pipe since that's a consumer / 
> producer output file.
> 
> The next patch adds new methods for the plugins to hook into the 
> open_pipe and open_read, to let a plugin produce a header. The 
> open_read method can also be used to do something when overruns are 
> detected.

thanks, applied.

> The last patch is a test patch AND SHOULD NOT BE APPLIED. It is just 
> an example in how to use the new methods to produce a header. It 
> simply makes the ftrace tracer produce a simple "Test header" before 
> any output.

thanks, not applied ;-)

	Ingo
