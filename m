Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbXGHPOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbXGHPOE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 11:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXGHPNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 11:13:54 -0400
Received: from il.qumranet.com ([82.166.9.18]:60287 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbXGHPNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 11:13:53 -0400
Message-ID: <4690FF37.7020801@qumranet.com>
Date: Sun, 08 Jul 2007 18:13:59 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       shaohua.li@intel.com
Subject: Re: [PATCH][RFC] kvm-scheduler integration
References: <11838994974161-git-send-email-avi@qumranet.com> <20070708133539.GA12597@elte.hu> <4690E973.7000606@qumranet.com> <20070708134850.GB22911@elte.hu> <4690EC47.6060904@qumranet.com> <20070708135905.GA24991@elte.hu>
In-Reply-To: <20070708135905.GA24991@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Avi Kivity <avi@qumranet.com> wrote:
>
>   
>>>> Won't that increase task_struct (16 bytes on 64-bit) unnecessarily?  
>>>> The function pointers are common to all virtual machines.
>>>>         
>>> well, this function pointer could then be reused by other virtual 
>>> machines as well, couldnt it?
>>>       
>> I don't get this.  If we add a couple of members to task_struct, it 
>> can't be reused.  The values will be the same across all tasks, but 
>> the memory will be gone (including tasks which aren't virtual 
>> machines).
>>     
>
> i mean, the function pointer is set by KVM, but it could be set to a 
> different value by other hypervisors.
>
>   

What other hypervisors? ;-)

Oh, if Rusty wants it for lguest I can put a pointer or a chain into 
task_struct.  But I doubt it -- with paravirtualization there are no 
costly new registers to swap.

> but ... no strong feelings either way, your patch is certainly fine.
>
> Acked-by: Ingo Molnar <mingo@elte.hu>
>   

Thanks!

-- 
error compiling committee.c: too many arguments to function

