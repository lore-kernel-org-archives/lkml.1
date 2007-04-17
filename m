Return-Path: <linux-kernel-owner+w=401wt.eu-S1031279AbXDQWDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031279AbXDQWDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031282AbXDQWDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:03:33 -0400
Received: from fb2.tech.numericable.fr ([82.216.111.50]:41199 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031245AbXDQWDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:03:32 -0400
X-Greylist: delayed 2005 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Apr 2007 18:03:32 EDT
Message-ID: <46253CE0.6020209@free.fr>
Date: Tue, 17 Apr 2007 23:32:16 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux.kernel@free.fr
Subject: Re: Disabling x86 System Management Mode
References: <46235447.3080000@free.fr> <p73odlo55q2.fsf@bingen.suse.de> <4624FA85.9010704@free.fr> <20070417165759.GA10145@one.firstfloor.org>
In-Reply-To: <20070417165759.GA10145@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:

> Modern x86 CPUs execute code out of order and in parallel.

I am aware of the (apparent) non-deterministic nature of
superscalar out-of-order speculative execution.

> The reordering window can be quite large and the CPU can execute code
> speculatively. This can add large errors to RDTSC when the 
> instruction is not executed where you think it is. One way around 
> this is to synchronize it -- using CPUID --

Your terminology is surprising. CPUID is commonly referred to as a
/serializing/ instruction.

> but that also adds latency and makes the measurement less precise.

Why would adding known latency make the measurement less precise?

What I needed was a block of code with consistent latency, whatever
the actual number.

Regards.
