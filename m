Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbXJBXk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbXJBXk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbXJBXkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:40:20 -0400
Received: from rtr.ca ([76.10.145.34]:2329 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbXJBXkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:40:19 -0400
Message-ID: <4702D6E1.4060705@rtr.ca>
Date: Tue, 02 Oct 2007 19:40:17 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Bostr?m <anders@bostrom.dyndns.org>,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>	<20071002150748.906970bc.akpm@linux-foundation.org>	<alpine.LFD.0.999.0710021514040.3579@woody.linux-foundation.org>	<4702CA3A.50600@rtr.ca> <20071002162247.26316b3b@laptopd505.fenrus.org>
In-Reply-To: <20071002162247.26316b3b@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 02 Oct 2007 18:46:18 -0400
>> On a related note, {set/get}itimer() currently are buggy (since
>> 2.6.11 or so), also due to this round_jiffies() thing I believe.
> 
> I very much believe that it is totally unrelated... most of all since
> round_jiffies() wasn't in the kernel then an also isn't used anywhere
> near these timers.

Ah, yes, you're correct.  The itimer routines do their *own* rounding.

-ml
