Return-Path: <linux-kernel-owner+w=401wt.eu-S1752252AbYI2PoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbYI2PoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 11:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYI2PoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 11:44:00 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:38193 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYI2PoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 11:44:00 -0400
Message-ID: <48E0F7B9.3040301@nortel.com>
Date: Mon, 29 Sep 2008 09:43:53 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: unpredictability in scheduler test results -- still present
References: <48D2DA0D.4060300@nortel.com> <48DA5A84.8030704@nortel.com> <48DACF55.3070209@nortel.com> <20080927200433.GC28937@elte.hu>
In-Reply-To: <20080927200433.GC28937@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2008 15:43:55.0683 (UTC) FILETIME=[2E522730:01C9224A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Chris Friesen <cfriesen@nortel.com> wrote:

>> It turns out that disabling CONFIG_DYNAMIC_FTRACE makes the load 
>> balancing problem go away and causes all cpus to be used.
>>
>> With this option enabled, the problem seems to be present as far back 
>> as 2.6.27-rc2.  (2.6.27-rc1 doesn't compile on my machine, and 2.6.26 
>> doesn't have ftrace).
>>
>> I have no idea why turning on dynamic ftrace would affect load 
>> balancing behaviour, but it's very repeatable.  The very first test 
>> run after booting works fine, and all successive runs fail to balance 
>> properly.

> OTOH, what does 'truning on dftrace' exactly mean? Just enabling it in 
> the .config, or also activating it via /debug/tracing/current_tracer?

Just enabling it in the .config is enough to trigger the behaviour 
change.  I'm not explicitly activating any traces.

Chris
