Return-Path: <linux-kernel-owner+w=401wt.eu-S933287AbXFEQQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287AbXFEQQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbXFEQQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:16:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763311AbXFEQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:16:22 -0400
Message-ID: <46658C41.9090105@zytor.com>
Date: Tue, 05 Jun 2007 09:16:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
References: <20070522223828.GV11115@waste.org>	<200706051201.32137.ak@suse.de>	<1181049060.14054.30.camel@localhost.localdomain>	<200706051624.53157.ak@suse.de> <20070605090714.22bfcfd4.akpm@linux-foundation.org>
In-Reply-To: <20070605090714.22bfcfd4.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 5 Jun 2007 16:24:52 +0200 Andi Kleen <ak@suse.de> wrote:
> 
>> On Tuesday 05 June 2007 15:11, Rusty Russell wrote:
>>> On Tue, 2007-06-05 at 12:01 +0200, Andi Kleen wrote:
>>>>> But TSC is a "required feature", so "cpu_has_tsc" is always true.
>>>> Hmm? It isn't. What makes you think so?
>>> Interestingly it seems to be only in -mm.
>> If it is then it doesn't come out of my tree. Also sounds broken to me.
>> The required bits are only for features needed by the compiler's generated
>> code where not having them could cause an early crash.

Yes.  Since there is now a mechanism to get a clean message out, it
seemed like a good idea to extend the benefit of static determination.
Andi already had in his tree -- and I copied it -- code to deal with
stuff like "cpu_has_tsc" as a compile-time constant, eliminating the
"else" clause.

Depending on the configuration it affects FPU, TSC, 3Dnow.

	-hpa
