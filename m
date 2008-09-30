Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYI3VOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYI3VOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYI3VO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:14:28 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:40483 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYI3VO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:14:27 -0400
Message-ID: <48E2969F.9000303@nortel.com>
Date: Tue, 30 Sep 2008 15:14:07 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: unpredictability in scheduler test results -- still present
References: <48D2DA0D.4060300@nortel.com> <48DA5A84.8030704@nortel.com> <48DACF55.3070209@nortel.com> <20080927200433.GC28937@elte.hu> <48E0F7B9.3040301@nortel.com> <20080930111217.GA21367@elte.hu>
In-Reply-To: <20080930111217.GA21367@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 21:14:09.0514 (UTC) FILETIME=[7AB294A0:01C92341]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Chris Friesen <cfriesen@nortel.com> wrote:
>> Ingo Molnar wrote:

>>> OTOH, what does 'truning on dftrace' exactly mean? Just enabling it in  
>>> the .config, or also activating it via /debug/tracing/current_tracer?

>> Just enabling it in the .config is enough to trigger the behaviour 
>> change.  I'm not explicitly activating any traces.

> ok, that would be a clear ftrace bug i guess?

It's either an ftrace bug or a fragile load balancer bug.  I wonder if 
it's related somehow to the stop_machine() call in ftrace_dynamic_init()?

Chris
