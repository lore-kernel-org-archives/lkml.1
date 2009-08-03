Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbZHCVHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbZHCVHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZHCVHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:07:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:53671 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbZHCVHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:07:21 -0400
Message-ID: <4A7750DE.3090501@windriver.com>
Date: Mon, 03 Aug 2009 16:04:30 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Dave Anderson <anderson@redhat.com>, crash-utility@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <clark.williams@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Jason Baron <jbaron@redhat.com>, srostedt@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][RFC][PATCH] Crash-utility, tracing: enable crash to
 analyze tracing from core-file (make tracing can act as a flight recorder)
References: <4A76F8A1.30503@cn.fujitsu.com><20090803151420.GA8712@infradead.org><1249312875.7924.106.camel@twins> <4A773EBD.3050707@windriver.com> <87ljm0tyb7.fsf@basil.nowhere.org>
In-Reply-To: <87ljm0tyb7.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2009 21:04:33.0704 (UTC) FILETIME=[004E3280:01CA147E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jason Wessel <jason.wessel@windriver.com> writes:
>   
>> In no particular order, tracing, kernel probes, profiling data display,
>> kdump, disassembly and kernel mode setting were some of the pieces that
>> are on the wish list for integration with the kdb prototype.  Kernel
>> mode setting is presently the highest priority on the wish list for a
>> new feature.
>>     
>
> I suspect for a lot of people the highest priority issue would be
> a polled USB keybord driver. Or do you plan to use the one from
> old kdb (iirc it was pretty crufty)
>
>   

There is a working usb keyboard driver in the kdb prototype.  I am not
certain about the degree to which the driver is robust or not.  I had
added a uhci implementation to the kdb prototype because I had a uhci
keyboard which didn't work at all.  The kdb usb code is quite complex
and not necessarily the long term approach to the problem.  That means
that if you have a uchi, ehci or ohci port on your board and typical usb
keyboard it has at least the possibility of working.

All these sorts of issues require a good deal of testing and review, 
right now it is at the stage where somethings work, and having other
people contribute to the project would be highly desired.

Jason.
