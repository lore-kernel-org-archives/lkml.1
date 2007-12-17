Return-Path: <linux-kernel-owner+w=401wt.eu-S1765847AbXLQQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765847AbXLQQmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755662AbXLQQmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:42:32 -0500
Received: from mga06.intel.com ([134.134.136.21]:33755 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752301AbXLQQmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:42:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,177,1196668800"; 
   d="scan'208";a="298590495"
Message-ID: <4766A692.5030008@linux.intel.com>
Date: Mon, 17 Dec 2007 08:40:50 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Jon Masters <jcm@redhat.com>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com>	 <4763F771.10105@s5r6.in-berlin.de>  <20071217025129.GA12815@redhat.com> <1197894814.18713.36.camel@perihelion> <4766760A.50902@s5r6.in-berlin.de>
In-Reply-To: <4766760A.50902@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Jon Masters wrote:
>> On Sun, 2007-12-16 at 21:51 -0500, Dave Jones wrote:
>>> On Sat, Dec 15, 2007 at 04:49:05PM +0100, Stefan Richter wrote:
>>>  
>>>  > Reports about tainted kernels have arguably less value.  It would be
>>>  > good to hide such reports until a report of the same oops in an
>>>  > untainted kernel was found.
>>>  
>>> I disagree with this.  It's useful to have a "we've seen this before,
>>> and every time, it was tainted with xyz module" datapoint, especially
>>> if no untainted copies of that oops turn up.
>> +1
>>
>> In fact, that's even more useful in many cases, if it helps demonstrate
>> that the oops is associated with a particular buggy binary driver. I can
>> see a lot of potentially interesting statistics coming from that too.
> 
> -1  :-)
> 
> I don't care at all what this xyz module does or does not do by and in
> itself.
> 

the thing is this: The goal of kerneloops.org is to allow developers to focus their effort on the real
important cases. Part of that is knowing which cases to dismiss/not spend time on because of their
relation with one or more binary drivers.... so imo keeping track of this and showing the "don't bother"
flag with it is very much worthwhile; it allows us developers to know what to ignore.

