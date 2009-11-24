Return-Path: <linux-kernel-owner+w=401wt.eu-S932676AbZKXKe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbZKXKe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932637AbZKXKe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:34:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbZKXKe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:34:27 -0500
Message-ID: <4B0BB6B1.5010302@redhat.com>
Date: Tue, 24 Nov 2009 12:34:25 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: kvmmmu tracing
References: <1258974375.7094.158.camel@johannes.local>	 <4B0BAC76.3080202@redhat.com> <1259057130.3985.1.camel@johannes.local>
In-Reply-To: <1259057130.3985.1.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2009 12:05 PM, Johannes Berg wrote:
> On Tue, 2009-11-24 at 11:50 +0200, Avi Kivity wrote:
>    
>> On 11/23/2009 01:06 PM, Johannes Berg wrote:
>>      
>>> Commit f691fe1da7e2715137d21ae5a80bec64db4625db is really broken wrt.
>>> the userspace interface for tracing because of the weird
>>> KVM_MMU_PAGE_PRINTK macro.
>>>
>>>
>>>        
>> Can you explain what is wrong with it?
>>      
> It's a big C expression that trace-cmd can't parse :)
>    

Um, C can be easily parsed with a C compiler.  I don't think you can 
expect it to be a plain format string and argument list.

>> Is userspace reading mmutrace.h?  When the structure attributes can be
>> exported via /sys/kernel/debug/tracing?
>>      
> Yes ... look
> at /sys/kernel/debug/tracing/events/kvmmmu/kvm_mmu_unsync_page/format
> for instance.
>    

You can fall back to using the attributes to build your own format string.

-- 
error compiling committee.c: too many arguments to function

