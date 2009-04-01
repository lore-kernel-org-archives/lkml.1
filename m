Return-Path: <linux-kernel-owner+w=401wt.eu-S1763790AbZDAMVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763790AbZDAMVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762907AbZDAMV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:21:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58878 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109AbZDAMV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:21:28 -0400
Date: Wed, 1 Apr 2009 14:21:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH v2] tracing/filters: add run-time field descriptions to
	TRACE_EVENT_FORMAT events
Message-ID: <20090401122122.GF12966@elte.hu>
References: <1238478529.6749.12.camel@bookworm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238478529.6749.12.camel@bookworm>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> The other is that for the really high-volume tracers e.g. the 
> function tracer, the volume of filtered events can be so high that 
> it pushes the unfiltered events out of the ring buffer before they 
> can be read so e.g. cat'ing the trace file repeatedly shows either 
> no output, or once in awhile some output but that isn't there the 
> next time you read the trace, which isn't what you normally expect 
> when reading the trace file. If you read from the trace_pipe file 
> though, you can catch them before they disappear.

yeah - this artifact of the ringbuffer needs to be fixed too. Steve, 
what's the plans on that?

	Ingo
