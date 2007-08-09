Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbXHITCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbXHITCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXHITCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:02:02 -0400
Received: from gw.goop.org ([64.81.55.164]:43047 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbXHITCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:02:00 -0400
Message-ID: <46BB6435.4070702@goop.org>
Date: Thu, 09 Aug 2007 12:00:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: i386 doublefault handler is broken with CONFIG_DEBUG_SPINLOCK
References: <46BB4599.2020900@redhat.com> <p73zm10egym.fsf@bingen.suse.de> <46BB5F9B.6050808@redhat.com>
In-Reply-To: <46BB5F9B.6050808@redhat.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 08/09/2007 01:49 PM, Andi Kleen wrote:
>   
>> Chuck Ebbert <cebbert@redhat.com> writes:
>>     
>>> Initializing FS in the doublefault_tss should fix it.
>>>
>>> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
>>>
>>> ---
>>>
>>>  NOTE: not even compile tested.
>>>       
>> Can you please test it?
>>
>>     
>
> It compiles but I can't really test it further right now.
>   

Looks correct in principle.

    J
