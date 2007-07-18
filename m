Return-Path: <linux-kernel-owner+w=401wt.eu-S1763269AbXGRTZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763269AbXGRTZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXGRTZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:25:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:41500 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbXGRTZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:25:21 -0400
Message-ID: <469E691D.3050305@codemonkey.ws>
Date: Wed, 18 Jul 2007 14:25:17 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Avi Kivity <avi@qumranet.com>, KVM devel <kvm-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 3/3] KVM - add hypercall nr to kvm_run
References: <20070716192447.GA16253@c2.user-mode-linux.org> <469C7C8D.1020600@qumranet.com> <469CCF17.3020709@codemonkey.ws> <20070717160710.GC7965@c2.user-mode-linux.org> <469E3FA2.7060408@codemonkey.ws> <20070718174104.GA8655@c2.user-mode-linux.org>
In-Reply-To: <20070718174104.GA8655@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Wed, Jul 18, 2007 at 11:28:18AM -0500, Anthony Liguori wrote:
>   
>> Within the kernel right (VMCALL is only usable in ring 1).  
>>     
>
> Yup.
>
>   
>> Is it 
>> terribly important to be able to pass through the syscall arguments in 
>> registers verses packing them in a data structure and passing a pointer 
>> to that structure?
>>     
>
> An arg block would be fine, too.
>   

Okay, then you should be pretty well insulated against the changing 
hypercall stuff since you only need one hypercall NR and can use a one 
argument hypercall.

Regards,

Anthony Liguori

> 				Jeff
>
>   

