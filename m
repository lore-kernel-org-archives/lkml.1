Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbXKRRh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbXKRRh2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 12:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXKRRhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 12:37:18 -0500
Received: from rtr.ca ([76.10.145.34]:4658 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbXKRRhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 12:37:17 -0500
Message-ID: <4740784A.7090405@rtr.ca>
Date: Sun, 18 Nov 2007 12:37:14 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Mark Lord <liml@rtr.ca>, Thomas Gleixner <tglx@linutronix.de>,
       len.brown@intel.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [BUG] Strange 1-second pauses during Resume-from-RAM
References: <32209efe0711122242m3a5f081asf1c11a38b24db10c@mail.gmail.com> <20071113031553.3c7b5c16.akpm@linux-foundation.org> <4739ADA2.4060604@rtr.ca> <alpine.LFD.0.9999.0711131521590.3265@localhost.localdomain> <4739E347.30406@rtr.ca> <473C7495.40805@rtr.ca> <47406400.5070804@rtr.ca> <20071118162126.GA29080@elte.hu>
In-Reply-To: <20071118162126.GA29080@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mark Lord <lkml@rtr.ca> wrote:
> 
>> Since Ingo's latency trace patches lock up the machine on resume, the 
>> next thing I'll try instead is to re-enable CONFIG_IRQBALANCE=y.
> 
> hm, which patch did you try? Could you check whether all chunks from the 
> patch below are applied? (these are the fixed i did when i was doing 
> cross-suspend traces - this is not something i've done before, so the 
> tracer had to be adjusted)
..

Hi Ingo!

I was using your 2.6.23.1 version of the patches, plus the fix you posted.

The new patch you gave just now is for 2.6.24, which won't apply to
the older kernel.  I'm not switching kernels yet, as doing so might mask
the problem without actually resolving it for good.

Cheers
