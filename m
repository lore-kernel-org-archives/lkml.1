Return-Path: <linux-kernel-owner+w=401wt.eu-S1759967AbXK1AGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967AbXK1AGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXK1AGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:06:39 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:32754 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbXK1AGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:06:39 -0500
Message-ID: <474CB0AD.2080800@oracle.com>
Date: Tue, 27 Nov 2007 16:05:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
References: <20071127001407.859743255@sgi.com> <20071127001430.313046247@sgi.com> <20071127154055.35e07833.randy.dunlap@oracle.com> <Pine.LNX.4.64.0711271600510.7293@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711271600510.7293@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 27 Nov 2007, Randy Dunlap wrote:
> 
>>> +config ARCH_SETS_UP_PER_CPU_AREA
>>> +	bool
>>> +	default y
>> 	def_bool y
>>   is the preferred form for those 2-liners above...
>>
>>
>>> +
>>>  config ARCH_NO_VIRT_TO_BUS
>>>  	def_bool y
>>>  
> 
> Ok. Changed.
> 
> x86 should use
> 
> config ARCH_SETS_UP_PER_CPU_AREA
>         def_bool X86_64
> 
> ?

Yes, you can do
	def_bool <config symbol>
as well to make the new symbol be variable instead of constant.


-- 
~Randy
