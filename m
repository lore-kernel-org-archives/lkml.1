Return-Path: <linux-kernel-owner+w=401wt.eu-S935203AbXGRRTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935203AbXGRRTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763090AbXGRRTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:19:43 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:38512 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762726AbXGRRTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:19:43 -0400
Message-ID: <469E4BB0.8010203@cfl.rr.com>
Date: Wed, 18 Jul 2007 13:19:44 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Rene Herman <rene.herman@gmail.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <200707111916.35036.jesper.juhl@gmail.com> <2c0942db0707112159v3ee2cd83i74759c7138e273f7@mail.gmail.com> <9a8748490707121324q3b3e6e65ye14ab8e7f089d999@mail.gmail.com> <4696C89E.4010002@goop.org> <9a8748490707121925w5fb22c0o61068f06d66d5845@mail.gmail.com <20070714191737.GA11166@waste.org>
In-Reply-To: <20070714191737.GA11166@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2007 17:19:51.0337 (UTC) FILETIME=[D99D0190:01C7C95F]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15306.000
X-TM-AS-Result: No--11.321300-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
>> As far as I'm aware, the actual reason for 4K stacks is that after the 
>> system has been up and running for some time getting "1 physically 
>> contiguous pages" becomes significantly easier than 2 which wouldn't be 
>> arbitrary.
> 
> If there are exactly two free pages in the system, the odds of them
> being buddies (ie adjacent AND properly aligned) is quite small. The
> available page pool has to grow quite a bit before the availability of
> order-1 page pairs approaches 100%. 
> 
> So if we fail to allocate an 8k stack when we could have allocated a
> 4k stack, we're almost certainly failing significantly prematurely.

Why do the two pages have to be physically contiguous?  The stack just 
needs to be two contiguous pages in virtual memory, but they can map to 
any two pages anywhere in physical memory.

