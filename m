Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbYJJKWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbYJJKWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 06:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbYJJKWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 06:22:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49392 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980AbYJJKWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 06:22:32 -0400
Message-ID: <48EF2CE0.3080109@firstfloor.org>
Date: Fri, 10 Oct 2008 12:22:24 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.14 (X11/20060911)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Update cacheline size on X86_GENERIC
References: <20081009171453.GA15321@redhat.com> <200810101428.23662.nickpiggin@yahoo.com.au> <87tzbksxja.fsf@basil.nowhere.org> <200810101945.32111.nickpiggin@yahoo.com.au>
In-Reply-To: <200810101945.32111.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:

> 
>>> Anyway, GENERIC kernel should run well on all architectures, and while
>>> going too big causes slightly increased structures sometimes, going too
>>> small could result in horrible bouncing.
>> Exactly.
>>
>> That is it costs one percent or so on TPC, but I think the fix
>> for that is just to analyze where the problem is and size those
>> data structures based on the runtime cache size. Some subsystems
>> like slab do this already.
> 
> Costs 1% on TPC? Is that 128 byte aligning data structures on
> Core2, or 64 byte aligning them on P4 that costs the performance?

The first. BTW it was a rough number from memory, in that ballpark.
Also the experiment was on older kernels, might be different now.

The second would undoubtedly be much worse.

-Andi
