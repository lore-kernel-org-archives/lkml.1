Return-Path: <linux-kernel-owner+w=401wt.eu-S933912AbXGRQ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbXGRQ2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932777AbXGRQ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:28:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:54189 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932931AbXGRQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:28:23 -0400
Message-ID: <469E3FA2.7060408@codemonkey.ws>
Date: Wed, 18 Jul 2007 11:28:18 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Avi Kivity <avi@qumranet.com>, KVM devel <kvm-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [PATCH 3/3] KVM - add hypercall nr to kvm_run
References: <20070716192447.GA16253@c2.user-mode-linux.org> <469C7C8D.1020600@qumranet.com> <469CCF17.3020709@codemonkey.ws> <20070717160710.GC7965@c2.user-mode-linux.org>
In-Reply-To: <20070717160710.GC7965@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Tue, Jul 17, 2007 at 09:15:51AM -0500, Anthony Liguori wrote:
>   
>> I'm planning on breaking this interface again since the new hypercall 
>> API only takes 4 arguments instead of 6.
>>     
>
> Is anything written anywhere about this hypercall interface?
>   

I've posted patches.  I'll post more in the near future since we decided 
to make some rather drastic changes.  With the new patchset, guest's 
will use vmcall directly with a couple bytes of padding.  The hypervisor 
may or may not patch the calling site to use something different (like 
vmmcall).

> The thing which would make me happy (which the current code comes
> close to) is for the guest to be able to pass out Linux system calls
> with VMCALL.
>   

Within the kernel right (VMCALL is only usable in ring 1).  Is it 
terribly important to be able to pass through the syscall arguments in 
registers verses packing them in a data structure and passing a pointer 
to that structure?

Regards,

Anthony Liguori

> 				Jeff
>
>   

