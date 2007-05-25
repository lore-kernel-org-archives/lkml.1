Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbXEYJgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbXEYJgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXEYJgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:36:25 -0400
Received: from c2bthomr06.btconnect.com ([213.123.20.138]:20851 "EHLO
	c2bthomr06.btconnect.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbXEYJgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:36:24 -0400
Message-ID: <4656AE10.4070104@onelan.co.uk>
Date: Fri, 25 May 2007 10:36:16 +0100
From: Barry Scott <barry.scott@onelan.co.uk>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: freegnu@163.com
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.17-rc6 No volume groups found
References: <4491540A.6050806@onelan.co.uk> <1180020784.9086.0.camel@localhost.localdomain>
In-Reply-To: <1180020784.9086.0.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Junkmail-Status: score=10/50, host=c2bthomr06.btconnect.com
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A090201.4656AE12.010D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2006-12-09 10:45:40,
	dmn=5.3.10/2007-02-21
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

freegnu wrote:
> i have the same problem when i built kernel 2.6.14.
> and the previous working kernel is 2.6.11 form Fedora Code 4
>
> anyone give me any adviece? thanks
>
>
> On Thu, 2006-06-15 at 13:35 +0100, Barry Scott wrote:
>   
>> On my HP dc7600U having patch around the MCG problem
>> I now get a bit further. Previous working kernel was 2.6.16
>> from Fedora Code 4.
>>
>> I see:
>>
>> Uncompressing Linux... Ok, botinh the kernel.
>> Red Hat nash version 4.2.15 starting
>>   Reading all physical volumes.  This may take a while...
>>   No volume groups found
>>   Unable to find volume group "VolGroup00"
>> ERROR: /bin/lvm exited abnormally with value 5 ! (pid 351)
>>
>> Then a few more errors and Kernel panic
>>
>> Where would the problem be?
>>
>> Barry
>>
>>     
You have to rebuild the initrd to match the kernel and its modules.
As the kernel develops the initrd scripts need to change to match changes
in modules required to support the disks for the new kernel.
I've no experience with 2.6.11 to 2.6.14. We now use 2.6.21
and know a bit about how to support it on FC4.

What we did to find differences was to run later versions of Fedora Core
that support the kernel we want to use out of the box. Then we break open
the initrd and see what the differences are between the old and new initrd
files.

Barry

