Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbXH1G6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbXH1G6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXH1G56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:57:58 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48900 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751426AbXH1G55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:57:57 -0400
Message-ID: <46D3C60B.3050605@vmware.com>
Date: Mon, 27 Aug 2007 23:51:55 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@qumranet.com>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
References: <46CBC842.4070100@vmware.com>  <46CBCADF.2070400@qumranet.com>	 <1187763956.6174.48.camel@localhost.localdomain> <1188237281.5972.69.camel@localhost.localdomain>
In-Reply-To: <1188237281.5972.69.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2007-08-22 at 16:25 +1000, Rusty Russell wrote:
>   
>> On Wed, 2007-08-22 at 08:34 +0300, Avi Kivity wrote:
>>     
>>> Zachary Amsden wrote:
>>>       
>>>> This patch provides hypercalls for the i386 port I/O instructions,
>>>> which vastly helps guests which use native-style drivers.  For certain
>>>> VMI workloads, this provides a performance boost of up to 30%.  We
>>>> expect KVM and lguest to be able to achieve similar gains on I/O
>>>> intensive workloads.
>>>>         
>>> Won't these workloads be better off using paravirtualized drivers? 
>>> i.e., do the native drivers with paravirt I/O instructions get anywhere
>>> near the performance of paravirt drivers?
>>>       
>> This patch also means I can kill off the emulation code in
>> drivers/lguest/core.c, which is a real relief.
>>     
>
> Hrm... how do you deal with X doing IOs ?
>
> Ben.
>   

We have an X driver that does minimal performance costing operations.  
As we should and will have for our other drivers.

Zach

