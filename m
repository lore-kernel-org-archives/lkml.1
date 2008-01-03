Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYACDv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYACDv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYACDvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:51:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbYACDvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:51:51 -0500
Message-ID: <477C5BB9.7020106@zytor.com>
Date: Wed, 02 Jan 2008 19:51:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fault_{32|64}.c unify do_page_fault
References: <1199322063.6323.72.camel@brick>	 <20080103014550.GA7377@martell.zuzino.mipt.ru> <1199326158.6323.87.camel@brick>
In-Reply-To: <1199326158.6323.87.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> 
> My apologies, testing/compiling on X86_32 here.
> 
>> Do you seriously think code is getting better and more readable because
>> of this liberal #ifdef sprinkling in every possible direction?
>>
> 
> Well, this of course is not the end of the road, but it makes it
> obvious where the differences between 32/64 bit lie and allows
> further cleanups to unify these areas over time.  This is meant as
> a no functionality change path at first.....and it does point out that
> for the most part the files are _very_ similar to each other.
> 
> So my plan for now was to move forward with no functional changes and
> esentially ifdef or reorder code until we get to identical fault_32/64.c
> which then gets moved to a single fault.c
> 
> Then the cleanups happen in one place in one file and it should be easy
> to audit the series at the end.  But for further patches I'll wait until
> the series is further along and tested before submitting.  This was how
> the kprobes unification went and I think it works fairly well this way.
> 

One more thing... for code motion/unification patches it's a good thing 
to verify that the i386 and x86-64 binaries are both unchanged.

	-hpa
