Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbXLDTSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbXLDTSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbXLDTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:18:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbXLDTSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:18:07 -0500
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Dave Hansen <haveblue@us.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mbligh@google.com
Subject: Re: [RFC PATCH] LTTng instrumentation mm (updated)
References: <20071116143019.GA16082@Krystal>
	<1195495485.27759.115.camel@localhost> <20071128140953.GA8018@Krystal>
	<1196268856.18851.20.camel@localhost> <20071129023421.GA711@Krystal>
	<1196317552.18851.47.camel@localhost> <20071130161155.GA29634@Krystal>
	<1196444801.18851.127.camel@localhost>
	<20071130170516.GA31586@Krystal> <1196448122.19681.16.camel@localhost>
	<20071130191006.GB3955@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 04 Dec 2007 14:15:32 -0500
In-Reply-To: <20071130191006.GB3955@Krystal> (Mathieu Desnoyers's message of "Fri, 30 Nov 2007 14:10:06 -0500")
Message-ID: <y0mve7ez2y3.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> [...]
>> > We would like to be able to tell which swap file the information has
>> > been written to/read from at any given time during the trace.
>> 
>> Oh, tracing is expected to be on at all times?  I figured someone would
>> encounter a problem, then turn it on to dig down a little deeper, then
>> turn it off.
>
> Yep, it can be expected to be on at all times, especially on production
> systems using "flight recorder" tracing to record information in a
> circular buffer [...]

Considering how early in the boot sequence swap partitions are
activated, it seems optimistic to assume that the monitoring equipment
will always start up in time to catch the initial swapons.  It would
be more useful if a marker parameter was included in the swap events
to let a tool/user map to /proc/swaps or a file name.

- FChE
