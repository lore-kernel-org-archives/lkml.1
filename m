Return-Path: <linux-kernel-owner+w=401wt.eu-S1751991AbZJDEYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbZJDEYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 00:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZJDEYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 00:24:09 -0400
Received: from ROUTE1.GET2SPEC.com ([98.174.230.194]:2381 "EHLO
	mail1.get2spec.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751324AbZJDEYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 00:24:07 -0400
X-Greylist: delayed 643 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Oct 2009 00:24:07 EDT
Message-ID: <4AC820B5.2050504@analograils.com>
Date: Sun, 04 Oct 2009 00:12:37 -0400
From: Kevin Bowling <kevinb@analograils.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Shirley Ma <mashirle@us.ibm.com>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Jones <drjones@redhat.com>
Subject: Re: INFO: task journal:337 blocked for more than 120 seconds
References: <1254345112.8837.9.camel@localhost.localdomain> <4AC646D7.5030709@goop.org>
In-Reply-To: <4AC646D7.5030709@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/2009 2:30 PM, Jeremy Fitzhardinge wrote:
> On 09/30/09 14:11, Shirley Ma wrote:
>    
>> Anybody found this problem before? I kept hitting this issue for 2.6.31
>> guest kernel even with a simple network test.
>>
>> INFO: task kjournal:337 blocked for more than 120 seconds.
>> "echo 0>  /proc/sys/kernel/hung_task_timeout_sec" disables this message.
>>
>> kjournald	D 00000041	0	337	2 0x00000000
>>
>> My test is totally being blocked.
>>      
> I'm assuming from the lists you've posted to that this is under KVM?
> What disk drivers are you using (virtio or emulated)?
>
> Can you get a full stack backtrace of kjournald?
>
> Kevin Bowling submitted a RH bug against Xen with apparently the same
> symptoms (https://bugzilla.redhat.com/show_bug.cgi?id=526627).  I'm
> wondering if there's a core kernel bug here, which is perhaps more
> easily triggered by the changed timing in a virtual machine.
>
> Thanks,
>      J
>    

I've had a stable system thus far by appending "clocksource=jiffies" to 
the kernel boot line.  The default clocksource is otherwise "xen".

The dmesg boot warnings in my bugzilla report still occur.

Regards,
Kevin Bowling
http://www.analograils.com/
