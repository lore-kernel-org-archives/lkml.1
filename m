Return-Path: <linux-kernel-owner+w=401wt.eu-S1754178AbXJVIwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbXJVIwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbXJVIvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:51:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:52868 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbXJVIvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:51:52 -0400
Message-ID: <471C647A.50908@qumranet.com>
Date: Mon, 22 Oct 2007 10:51:06 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Laurent Vivier <Laurent.Vivier@bull.net>, linux-kernel@vger.kernel.org,
       borntraeger@de.ibm.com, kvm-devel@lists.sourceforge.net
Subject: Re: [PATCH] move kvm_guest_exit() after local_irq_enable()
References: <47135D1B.1060004@bull.net> <11927135412363-git-send-email-Laurent.Vivier@bull.net> <20071022082604.GA28528@elte.hu>
In-Reply-To: <20071022082604.GA28528@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Laurent Vivier <Laurent.Vivier@bull.net> wrote:
>
>   
>> According comments from Avi, we can clear PF_VCPU in kvm_guest_exit if 
>> we move it after local_irq_enable().
>>
>> http://lkml.org/lkml/2007/10/15/114
>>
>> To simplify s390 port, we don't clear it in account_system_time().
>>
>> http://lkml.org/lkml/2007/10/15/183
>>     
>
> thanks - i have picked your patch up.
>
>   

Note the kvm part is already in my 2.6.24 queue.


-- 
error compiling committee.c: too many arguments to function

