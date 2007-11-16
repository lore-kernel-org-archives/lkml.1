Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbXKPSg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbXKPSg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:36:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761690AbXKPSfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:35:32 -0500
Received: from rtr.ca ([76.10.145.34]:4894 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759891AbXKPSfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:35:31 -0500
Message-ID: <473DE2F0.2060808@rtr.ca>
Date: Fri, 16 Nov 2007 13:35:28 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <20071115181418.GA6603@ucw.cz> <473C825E.3030307@rtr.ca> <20071115193424.GA31691@elte.hu> <20071115193612.GA751@elte.hu> <473CC6D4.2010909@rtr.ca>
In-Reply-To: <473CC6D4.2010909@rtr.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> pick up the latest latency tracer patch from:
>>
>> sorry, wrong URLs, the correct links are:
>>
>>    
>> http://redhat.com/~mingo/latency-tracing-patches/latency-tracer-v2.6.24-rc2-git5-combo.patch 
>>
>>    http://redhat.com/~mingo/latency-tracing-patches/trace-cmd.c
..

make trace-cmd
cc -Wall -O2 -s    trace-cmd.c   -o trace-cmd
trace-cmd.c: In function ‘main’:
trace-cmd.c:65: warning: label ‘usage’ defined but not used

