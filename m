Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbXISOO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbXISOO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXISOOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:14:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53379 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbXISOOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:14:49 -0400
Message-ID: <46F12ED7.3060605@us.ibm.com>
Date: Wed, 19 Sep 2007 07:14:47 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de>
In-Reply-To: <p736427vz00.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "David J. Wilder" <dwilder@us.ibm.com> writes:
> 
> Not having read the whole thing; just something I noticed.
> 
> Gut feeling is that you have too many knobs and options and 
> some overengineering though -- simplifying it would be a good thing.
> 
>> +
>> +#define TRACE_PRINTF_TMPBUF_SIZE (1024)
>> +static char trace_tmpbuf[NR_CPUS][TRACE_PRINTF_TMPBUF_SIZE];
> 
> That definitely needs to be a per CPU variable. Imagine
> what happens on a NR_CPUS==4096 kernel.  In general when 
> you have a NR_CPUS indexed array you're likely doing something
> wrong. Yes there are still places in the main tree who do that,
> but most of them need to be fixed.

I agree with you; however, this is in the example code in the 
Documentation directory,  It is not part of the trace code.  The example 
was just meant to be a demonstration of how the interface works.
> 
> -Andi
> 

