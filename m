Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbYLIQk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbYLIQk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYLIQkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:40:12 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:49108 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbYLIQkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:40:10 -0500
Message-ID: <493E9F3E.3020902@nortel.com>
Date: Tue, 09 Dec 2008 10:39:26 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: eranian@gmail.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Subject: Re: [patch] Performance Counters for Linux, v2
References: <20081208012211.GA23106@elte.hu> <7c86c4470812082237ne58c814s7218cc663f3b49e9@mail.gmail.com> <20081209134636.GA1926@elte.hu>
In-Reply-To: <20081209134636.GA1926@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Dec 2008 16:39:28.0878 (UTC) FILETIME=[B46398E0:01C95A1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> When there are two (or more) hw metrics to profile, the ideally best 
> (i.e. the statistically most stable and most relevant) sampling for the 
> two statistical variables (say of l2_misses versus l2_accesses) is to 
> sample them independently, via their own metric. Not via a static 1khz 
> rate - or via picking one of the variables to generate samples.

Regardless of sampling method, don't you still want some way to 
enable/disable the various counters as close to simultaneously as possible?

Chris
